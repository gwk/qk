// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import UIKit


extension UIScrollView {

  var contentRect: CGRect { return CGRect(CGPoint(), contentSize) }
  
  var contentCenter: CGPoint { return CGPoint(contentSize) * 0.5 }
  
  var contentOffsetFracX: Flt {
    get {
      let vw = bounds.w
      let cw = contentSize.w
      let l = contentInset.l
      let x = contentOffset.x // range of x is -l to l + cw - w
      let xMin = -l
      let xMax = l + cw - vw
      let fracX = (x - xMin) / (xMax - xMin)
      return fracX
    }
    set {
      let vw = bounds.w
      let cw = contentSize.w
      let l = contentInset.l
      let x = contentOffset.x // range of x is -l to l + cw - w
      let xMin = -l
      let xMax = l + cw - vw
      contentOffset.x = newValue * (xMax - xMin) + xMin
    }
  }
  
  func setContentOffsetClamped(contentOffset: CGPoint, animated: Bool) {
    let bs = bounds.s
    let cs = contentSize
    let co = contentOffset
    let o = CGPoint(clamp(co.x, 0, cs.w - bs.w), clamp(co.y, 0, cs.h - bs.h))
    setContentOffset(o, animated: animated)
  }
  
  func centerOnContentPoint(point: CGPoint, animated: Bool) {
    // bounds half: the 'center' of bounds.size; not offset by origin like bounds center.
    let bh = CGPoint(bounds.s) * 0.5
    let o = point - bh
    setContentOffsetClamped(contentOffset, animated: animated)
  }
  
  func centerOnContentRect(rect: CGRect, animated: Bool) {
    let bs = CGPoint(bounds.s)
    let rs = CGPoint(rect.s)
    let o = rect.o - (bs - rs) * 0.5
    setContentOffsetClamped(o, animated: animated)
  }
  
  
}

