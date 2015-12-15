// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


typealias PanAction = (QKUIPanRecognizer) -> ()


class QKUIPanRecognizer: UIPanGestureRecognizer {
  
  class Handler: NSObject {
    var action: PanAction
    
    init(action: PanAction) {
      self.action = action
      super.init()
    }
    
    func handleGesture(gestureRecognizer: UIGestureRecognizer) {
      action(gestureRecognizer as! QKUIPanRecognizer)
    }
  }
  
  let handler: Handler
  
  init(view: UIView? = nil, delegate: UIGestureRecognizerDelegate? = nil, minTouches: Int = 1, maxTouches: Int = Int.max, action: PanAction = {(r) in return ()}) {
    assert(minTouches > 0 && maxTouches > 0 && minTouches <= maxTouches)
    handler = Handler(action: action)
    // since we cannot pass self as the target, we need the proxy Handler.
    super.init(target: handler, action: "handleGesture:")
    if let view = view {
      view.addGestureRecognizer(self)
    }
    self.delegate = delegate
    self.minimumNumberOfTouches = minTouches
    self.maximumNumberOfTouches = maxTouches

  }
  
  var action: PanAction {
    get { return handler.action }
    set { handler.action = newValue }
  }
}
