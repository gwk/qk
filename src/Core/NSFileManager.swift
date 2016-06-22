// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


let fileManager = FileManager.default()


func absolutePath(_ path: String) -> String? {
  let cr = fileManager.fileSystemRepresentation(withPath: path)
  let ca = realpath(cr, nil)
  if ca == nil {
    return nil
  }
  let a = fileManager.string(withFileSystemRepresentation: ca!, length: Int(strlen(ca)))
  free(ca)
  return a
}

func isPathFileOrDir(_ path: String) -> Bool {
  return fileManager.fileExists(atPath: path)
}

func isPathFile(_ path: String) -> Bool {
  var isDir: ObjCBool = false
  let exists = fileManager.fileExists(atPath: path, isDirectory: &isDir)
  return exists && !isDir
}

func isPathDir(_ path: String) -> Bool {
  var isDir: ObjCBool = false
  let exists = fileManager.fileExists(atPath: path, isDirectory: &isDir)
  return exists && isDir
}

func removeFileOrDir(_ path: String) throws {
  try fileManager.removeItem(atPath: path)
}

func createDir(_ path: String, intermediates: Bool = false) throws {
  try fileManager.createDirectory(atPath: path,
    withIntermediateDirectories: intermediates,
    attributes: nil)
}

func listDir(_ path: String) throws -> [String] {
  return try fileManager.contentsOfDirectory(atPath: path)
}

