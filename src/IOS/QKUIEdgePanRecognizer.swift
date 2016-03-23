// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


typealias EdgePanAction = (QKUIEdgePanRecognizer) -> ()


class QKUIEdgePanRecognizer: UIScreenEdgePanGestureRecognizer {
  
  class Handler: NSObject {
    var action: EdgePanAction
    
    init(action: EdgePanAction) {
      self.action = action
      super.init()
    }
    
    func handleGesture(gestureRecognizer: UIGestureRecognizer) {
      action(gestureRecognizer as! QKUIEdgePanRecognizer)
    }
  }
  
  let handler: Handler
  
  init(view: UIView? = nil, delegate: UIGestureRecognizerDelegate? = nil, edges: UIRectEdge, action: EdgePanAction = {(r) in return ()}) {
    handler = Handler(action: action)
    // since we cannot pass self as the target, we need the proxy Handler.
    super.init(target: handler, action: "handleGesture:")
    if let view = view {
      view.addGestureRecognizer(self)
    }
    self.delegate = delegate
    self.edges = edges
  }
  
  var action: EdgePanAction {
    get { return handler.action }
    set { handler.action = newValue }
  }
}
