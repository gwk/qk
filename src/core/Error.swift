// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.


typealias LazyErrorInfo = () -> [String:Any]

enum ErrorInfo {
  case Lazy(LazyErrorInfo)
  case Forced([String:Any])
}

var _errorCodes: [String:Uns] = [:]

func errorCode(name: String) -> Uns {
  if let i = _errorCodes[name] {
    return i
  }
  let i = Uns(_errorCodes.count)
  _errorCodes[name] = i
  return i
}


class Error {
  let code: Uns
  var _info: ErrorInfo
  
  var info: [String:Any] {
    switch _info {
    case .Lazy(let l):
      let i = l()
      _info = .Forced(i)
      return i
    case .Forced(let i):
      return i
    }
  }
  
  init(_ name: String, _ lazyInfo: () -> [String:Any] = {[:]}) {
    code = errorCode(name)
    _info = .Lazy(lazyInfo)
  }
}