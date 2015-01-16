// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

import UIKit


typealias SwipeGestureAction = (QKUISwipeRecognizer) -> ()


class QKUISwipeRecognizer: UISwipeGestureRecognizer {
  
  class Handler: NSObject {
    var action: SwipeGestureAction
    
    init(action: SwipeGestureAction) {
      self.action = action
      super.init()
    }
    
    func handleGesture(gestureRecognizer: UIGestureRecognizer) {
      action(gestureRecognizer as QKUISwipeRecognizer)
    }
  }
  
  let handler: Handler
  
  init(direction: UISwipeGestureRecognizerDirection, numTouches: Int = 1, action: SwipeGestureAction = {(r: QKUISwipeRecognizer) in return ()}) {
    handler = Handler(action: action)
    // since we cannot pass self as the target, we need the proxy Handler to pass as the target.
    super.init(target: handler, action: "handleGesture:")
    self.direction = direction
    self.numberOfTouchesRequired = numTouches
  }
  
  var action: SwipeGestureAction {
    get { return handler.action }
    set { handler.action = newValue }
  }
}
