// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics


extension CGMutablePath {

  func moveToPoint(point: CGPoint) {
    CGPathMoveToPoint(self, nil, point.x, point.y)
  }

  func addLines(points: [CGPoint]) {
    CGPathAddLines(self, nil, points, points.count)
  }
}