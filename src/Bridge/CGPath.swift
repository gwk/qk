// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics


extension CGPath {

  static func with(loopPoints points: [CGPoint]) -> CGPath {
    let path = CGPathCreateMutable()
    path.addLines(points)
    path.closeSubpath()
    return path
  }
}


extension CGMutablePath {

  func moveToPoint(point: CGPoint) {
    CGPathMoveToPoint(self, nil, point.x, point.y)
  }

  func addLines(points: [CGPoint]) {
    CGPathAddLines(self, nil, points, points.count)
  }

  func closeSubpath() {
    CGPathCloseSubpath(self)
  }
}