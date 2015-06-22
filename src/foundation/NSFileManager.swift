// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


let fileManager = NSFileManager.defaultManager()


func absolutePath(path: String) -> String? {
  let cr = fileManager.fileSystemRepresentationWithPath(path)
  let ca = realpath(cr, nil)
  if ca == nil {
    return nil
  }
  let a = fileManager.stringWithFileSystemRepresentation(ca, length: Int(strlen(ca)))
  free(ca)
  return a
}

func isPathFileOrDir(path: String) -> Bool {
  return fileManager.fileExistsAtPath(path)
}

func isPathFile(path: String) -> Bool {
  var isDir: ObjCBool = false
  let exists = fileManager.fileExistsAtPath(path, isDirectory: &isDir)
  return exists && !isDir
}

func isPathDir(path: String) -> Bool {
  var isDir: ObjCBool = false
  let exists = fileManager.fileExistsAtPath(path, isDirectory: &isDir)
  return exists && isDir
}

func removeFileOrDir(path: String) -> NSError? {
  var e: NSError? = nil
  do {
    try fileManager.removeItemAtPath(path)
  } catch var error as NSError {
    e = error
  }
  return e
}

func createDir(path: String, intermediates: Bool = false) -> NSError? {
  var e: NSError? = nil
  do {
    try fileManager.createDirectoryAtPath(path,
      withIntermediateDirectories: intermediates,
      attributes: nil)
  } catch var error as NSError {
    e = error
  }
  return e
}

func listDir(path: String) -> ([String], NSError?) {
  var e: NSError? = nil
  let l: [AnyObject]?
  do {
    l = try fileManager.contentsOfDirectoryAtPath(path)
  } catch var error as NSError {
    e = error
    l = nil
  }
  return (l as! [String], e)
}

