// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


typealias SwipeAction = (QKUISwipeRecognizer) -> ()


class QKUISwipeRecognizer: UISwipeGestureRecognizer {
  
  class Handler: NSObject {
    var action: SwipeAction
    
    init(action: SwipeAction) {
      self.action = action
      super.init()
    }
    
    func handleGesture(gestureRecognizer: UIGestureRecognizer) {
      action(gestureRecognizer as! QKUISwipeRecognizer)
    }
  }
  
  let handler: Handler
  
  init(view: UIView? = nil, delegate: UIGestureRecognizerDelegate? = nil, direction: UISwipeGestureRecognizerDirection, numTouches: Int = 1, action: SwipeAction = {(r) in ()}) {
    handler = Handler(action: action)
    // since we cannot pass self as the target, we need the proxy Handler.
    super.init(target: handler, action: "handleGesture:")
    if let view = view {
      view.addGestureRecognizer(self)
    }
    self.delegate = delegate
    self.direction = direction
    self.numberOfTouchesRequired = numTouches
  }
  
  var action: SwipeAction {
    get { return handler.action }
    set { handler.action = newValue }
  }
}
