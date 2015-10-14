// Copyright © 2015 George King. Permission to use this file is granted in ploy/license.txt.

import Darwin


class File: CustomStringConvertible {
  // the File classs encapsulates a system file descriptor.
  // the design is intended to:
  // prevent misuse of the file descriptor that could lead to problems like file descriptor leaks.
  // for example, calling close on a raw file descriptor could allow that descriptor to be reassigned to a new file;
  // aliases of that descriptor will then misuse the new file.

  typealias Descriptor = Int32
  typealias Stats = Darwin.stat
  typealias Perms = mode_t

  enum Error: ErrorType {
    case ChangePerms(path: String, perms: Perms)
    case Copy(from: String, to: String)
    case Open(path: String, msg: String)
    case Read(path: String, offset: Int, len: Int)
    case ReadMalloc(path: String, len: Int)
    case Seek(path: String, pos: Int)
    case Stat(path: String, msg: String)
    case Utf8Decode(path: String)
  }

  let path: String
  private let descriptor: Descriptor

  deinit {
    if Darwin.close(descriptor) != 0 { errL("WARNING: File.close failed: \(self); \(stringForCurrentError())") }
  }
  
  init(path: String, descriptor: Descriptor) {
    guard descriptor >= 0 else { fatalError("bad file descriptor for File at path: \(path)") }
    self.path = path
    self.descriptor = descriptor
  }

  class func openDescriptor(path: String, mode: CInt, create: Perms? = nil) throws -> Descriptor {
    var descriptor: Descriptor
    if let perms = create {
      descriptor = Darwin.open(path, mode | O_CREAT, perms)
    } else {
      descriptor = Darwin.open(path, mode)
    }
    guard descriptor >= 0 else { throw Error.Open(path: path, msg: stringForCurrentError()) }
    return descriptor
  }

  convenience init(path: String, mode: CInt, create: Perms? = nil) throws {
    self.init(path: path, descriptor: try File.openDescriptor(path, mode: mode, create: create))
  }
  
  var description: String {
    return "\(self.dynamicType)(path:'\(path)', descriptor: \(descriptor))"
  }

  func stats() throws -> Stats {
    var stats = Darwin.stat()
    let res = Darwin.fstat(descriptor, &stats)
    guard res == 0 else { throw Error.Stat(path: path, msg: stringForCurrentError()) }
    return stats
  }

  func seekAbs(pos: Int) throws {
    guard Darwin.lseek(descriptor, off_t(pos), SEEK_SET) == 0 else { throw Error.Seek(path: path, pos: pos) }
  }

  func rewind() throws {
    try seekAbs(0)
  }

  func rewindMaybe() -> Bool {
    do {
      try rewind()
    } catch {
      return false
    }
    return true
  }

  static func changePerms(path: String, _ perms: Perms) throws {
    guard Darwin.chmod(path, perms) == 0 else { throw Error.ChangePerms(path: path, perms: perms) }
  }

  func copy(fromPath fromPath: String, toPath: String, create: Perms? = nil) throws {
    try InFile(path: fromPath).copyTo(OutFile(path: toPath, create: create))
  }
}


class InFile: File {

  convenience init(path: String, create: Perms? = nil) throws {
    self.init(path: path, descriptor: try File.openDescriptor(path, mode: O_RDONLY, create: create))
  }

  func len() throws -> Int { return try Int(stats().st_size) }
  
  func readAbs(offset offset: Int, len: Int, ptr: UnsafeMutablePointer<Void>) throws -> Int {
    let len_act = Darwin.pread(Int32(descriptor), ptr, len, off_t(offset))
    guard len_act >= 0 else { throw Error.Read(path: path, offset: offset, len: len) }
    return len_act
  }
  
  func readText() throws -> String {
    let len = try self.len()
    let bufferLen = len + 1
    let buffer = malloc(bufferLen)
    guard buffer != nil else { throw Error.ReadMalloc(path: path, len: len) }
    let len_act = try readAbs(offset: 0, len: len, ptr: buffer)
    guard len_act == len else { throw Error.Read(path: path, offset: 0, len: len) }
    let charBuffer = unsafeBitCast(buffer, UnsafeMutablePointer<CChar>.self)
    charBuffer[len] = 0 // null terminator.
    let (s, _) = String.fromCStringRepairingIllFormedUTF8(charBuffer)
    free(buffer)
    guard let res = s else { throw Error.Utf8Decode(path: path) }
    return res
  }
  
  func copyTo(outFile: OutFile) throws {
    let attrs: Int32 = COPYFILE_ACL|COPYFILE_STAT|COPYFILE_XATTR|COPYFILE_DATA
    guard Darwin.fcopyfile(self.descriptor, outFile.descriptor, copyfile_state_t(), copyfile_flags_t(attrs)) == 0 else {
      throw Error.Copy(from: path, to: outFile.path)
    }
  }

  static func readText(path: String) throws -> String {
    let f = try InFile(path: path)
    return try f.readText()
  }

  static func readTextOrFail(path: String) throws -> String {
    let f = try InFile(path: path)
    return try f.readText()
  }
}


class OutFile: File, OutputStreamType {
  
  convenience init(path: String, create: Perms? = nil) throws {
    self.init(path: path, descriptor: try File.openDescriptor(path, mode: O_WRONLY | O_TRUNC, create: create))
  }

  func write(string: String) {
    string.nulTerminatedUTF8.withUnsafeBufferPointer {
      (buffer: UnsafeBufferPointer<UTF8.CodeUnit>) -> () in
        Darwin.write(descriptor, buffer.baseAddress, buffer.count - 1) // do not write null terminator.
    }
  }

  func writeL(string: String) {
    write(string)
    write("\n")
  }
  
  func setPerms(perms: Perms) {
    if Darwin.fchmod(descriptor, perms) != 0 {
      fail("setPerms(\(perms)) failed: \(stringForCurrentError()); '\(path)'")
    }
  }
}


var std_in = InFile(path: "std_in", descriptor: STDIN_FILENO)
var std_out = OutFile(path: "std_out", descriptor: STDOUT_FILENO)
var std_err = OutFile(path: "std_err", descriptor: STDERR_FILENO)


func out<T>(item: T)  { print(item, separator: "", terminator: "", toStream: &std_out) }
func outL<T>(item: T) { print(item, separator: "", terminator: "\n", toStream: &std_out) }

func err<T>(item: T)  { print(item, separator: "", terminator: "", toStream: &std_err) }
func errL<T>(item: T) { print(item, separator: "", terminator: "\n", toStream: &std_err) }

func errSL(items: Any...) {
  std_err.write(items, sep: " ", end: "\n")
}

func warn(items: Any...) {
  err("WARNING: ")
  std_err.write(items, sep: " ", end: "\n")
}