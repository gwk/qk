// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics


extension CGPath {

  static func with(loopPoints points: [CGPoint]) -> CGPath {
    let path = CGMutablePath()
    path.addLines(points)
    path.closeSubpath()
    return path
  }
}


extension CGMutablePath {

  func moveToPoint(_ point: CGPoint) {
    self.moveTo(nil, x: point.x, y: point.y)
  }

  func addLines(_ points: [CGPoint]) {
    self.addLines(nil, between: points, count: points.count)
  }

  func closeSubpath() {
    self.closeSubpath()
  }
}
