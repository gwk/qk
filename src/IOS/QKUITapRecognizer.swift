// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


typealias TapAction = (QKUITapRecognizer) -> ()


class QKUITapRecognizer: UITapGestureRecognizer {
  
  class Handler: NSObject {
    var action: TapAction
    
    init(action: TapAction) {
      self.action = action
      super.init()
    }
    
    func handleGesture(gestureRecognizer: UIGestureRecognizer) {
      action(gestureRecognizer as! QKUITapRecognizer)
    }
  }
  
  let handler: Handler
  
  init(view: UIView? = nil, delegate: UIGestureRecognizerDelegate? = nil, numTaps: Int = 1, numTouches: Int = 1, action: TapAction = {(r) in ()}) {
    handler = Handler(action: action)
    // since we cannot pass self as the target, we need the proxy Handler.
    super.init(target: handler, action: "handleGesture:")
    if let view = view {
      view.addGestureRecognizer(self)
    }
    self.delegate = delegate
    self.numberOfTapsRequired = numTaps
    self.numberOfTouchesRequired = numTouches
  }
  
  var action: TapAction {
    get { return handler.action }
    set { handler.action = newValue }
  }
}
