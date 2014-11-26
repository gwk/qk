// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias LOP = NSLayoutPriority
  //let LOPReq = NSLayoutPriorityRequired // TODO: swift currently omits the 'static' storage type, causing linker error.
  let LOPReq = LOP(1000)
  let LOPHigh = LOP(750)
  let LOPDragThatCanResizeWindow = LOP(510)
  let LOPWindowSizeStayPut = LOP(500)
  let LOPDragThatCannotResizeWindow = LOP(490)
  let LOPLow = LOP(250)
  let LOPFit = LOP(50)
  #else
  import UIKit
  typealias LOP = UILayoutPriority
  //let LOPReq = UILayoutPriorityRequired // TODO: swift currently omits the 'static' storage type, causing linker error.
  let LOPReq = LOP(1000)
  let LOPHigh = LOP(750)
  let LOPLow = LOP(250)
  let LOPFit = LOP(50)
#endif


struct QKLayoutOperand {
  let v: CRView
  let a: NSLayoutAttribute
}


extension CRView {
  
  func layoutOperand(attr: NSLayoutAttribute) -> QKLayoutOperand {
    return QKLayoutOperand(v: self, a: attr)
  }
  
  var l: QKLayoutOperand { return layoutOperand(.Left) }
  var r: QKLayoutOperand { return layoutOperand(.Right) }
  var t: QKLayoutOperand { return layoutOperand(.Top) }
  var b: QKLayoutOperand { return layoutOperand(.Bottom) }
  
  var ld: QKLayoutOperand { return layoutOperand(.Leading) }
  var tr: QKLayoutOperand { return layoutOperand(.Trailing) }
  
  var w: QKLayoutOperand { return layoutOperand(.Width) }
  var h: QKLayoutOperand { return layoutOperand(.Height) }
  var cx: QKLayoutOperand { return layoutOperand(.CenterX) }
  var cy: QKLayoutOperand { return layoutOperand(.CenterY) }
  
  var base: QKLayoutOperand { return layoutOperand(.Baseline) }
  
  var usesARMask: Bool {
    get {
      #if os(OSX)
        return translatesAutoresizingMaskIntoConstraints
        #else
        return translatesAutoresizingMaskIntoConstraints()
      #endif
      }
    set {
      #if os(OSX)
        translatesAutoresizingMaskIntoConstraints = newValue
        #else
      setTranslatesAutoresizingMaskIntoConstraints(newValue)
      #endif
    }
  }
}


protocol QKLayoutConstraining {
  // allows for constraints and format strings to be specified in the same variadic call;
  // this is syntactically convenient, and also allows for simultaneous activation of all constraints,
  // which is more performant, according to the comments around NSLayoutConstraint.activateConstraints.
  func constraintArray(views: [String: CRView], metrics: [String: NSNumber], opts: NSLayoutFormatOptions) -> [NSLayoutConstraint];
}


extension NSLayoutConstraint: QKLayoutConstraining {
  
  convenience init(_ rel: NSLayoutRelation, _ l: QKLayoutOperand, _ r: QKLayoutOperand? = nil, _ m: Flt = 1.0, _ c: Flt = 0.0,
    _ p: LOP = LOPReq) {
      var rv: CRView? = nil
      var ra = NSLayoutAttribute.NotAnAttribute
      if let ur = r {
        rv = ur.v
        ra = ur.a
      }
      self.init(item: l.v, attribute: l.a, relatedBy: rel, toItem: rv, attribute: ra, multiplier: m,  constant: c)
      priority = p
  }
  
  var lv: CRView { return firstItem as CRView }
  var la: NSLayoutAttribute { return firstAttribute }
  var rv: CRView? { return secondItem as CRView? }
  var ra: NSLayoutAttribute { return secondAttribute }
  
  func constraintArray(views: [String: CRView], metrics: [String: NSNumber], opts: NSLayoutFormatOptions) -> [NSLayoutConstraint] {
    return [self] // ignore all the format-related arguments.
  }
}


extension String: QKLayoutConstraining {
  
  func constraintArray(views: [String: CRView], metrics: [String: NSNumber], opts: NSLayoutFormatOptions) -> [NSLayoutConstraint] {
    return NSLayoutConstraint.constraintsWithVisualFormat(self, options: opts, metrics: metrics, views: views) as [NSLayoutConstraint]
  }
}


func eq(l: QKLayoutOperand, _ r: QKLayoutOperand? = nil, m: Flt = 1.0, c: Flt = 1.0, p: LOP = LOPReq) -> NSLayoutConstraint {
  return NSLayoutConstraint(.Equal, l, r, m, c, p)
}


func constrain(views: [String: CRView], #metrics: [String: NSNumber], #opts: NSLayoutFormatOptions, #constraints: [QKLayoutConstraining]) {
  for v in views.values {
    v.usesARMask = false
  }
  var allConstraints: [NSLayoutConstraint] = []
  for c in constraints {
    allConstraints.extend(c.constraintArray(views, metrics: metrics, opts: opts))
  }
  NSLayoutConstraint.activateConstraints(allConstraints)
}


func constrain(views: [String: CRView], #metrics: [String: NSNumber], #opts: NSLayoutFormatOptions, constraints: QKLayoutConstraining...) {
  constrain(views, metrics: metrics, opts: opts, constraints: constraints)
}

func constrain(views: [String: CRView], #metrics: [String: NSNumber], constraints: QKLayoutConstraining...) {
  constrain(views, metrics: metrics, opts: NSLayoutFormatOptions(0), constraints: constraints)
}

func constrain(views: [String: CRView], #opts: NSLayoutFormatOptions, constraints: QKLayoutConstraining...) {
  constrain(views, metrics: [:], opts: opts, constraints: constraints)
}

func constrain(views: [String: CRView], constraints: QKLayoutConstraining...) {
  constrain(views, metrics: [:], opts: NSLayoutFormatOptions(0), constraints: constraints)
}

