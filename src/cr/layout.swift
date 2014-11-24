// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias LOP = NSLayoutPriority
  let LOPReq = NSLayoutPriorityRequired
  #else
  import UIKit
  typealias LOP = UILayoutPriority
  //let LOPReq = UILayoutPriorityRequired // TODO: swift currently omits the 'static' storage type, causing linker error.
  let LOPReq  = UILayoutPriority(1000)
  let LOPHigh = UILayoutPriority(750)
  let LOPLow  = UILayoutPriority(250)
  let LOPFit  = UILayoutPriority(50)
#endif

/*
let UILayoutPriorityRequired: UILayoutPriority // A required constraint.  Do not exceed this.
let UILayoutPriorityDefaultHigh: UILayoutPriority // This is the priority level with which a button resists compressing its content.
let UILayoutPriorityDefaultLow: UILayoutPriority // This is the priority level at which a button hugs its contents horizontally.
let UILayoutPriorityFittingSizeLevel: UILayoutPriority // When you send -[UIView systemLayoutSizeFittingSize:], the size fitting most closely to the target size (the argument) is computed.  UILayoutPriorityFittingSizeLevel is the priority level with which the view wants to conform to the target size in that computation.  It's quite low.  It is generally not appropriate to make a constraint at exactly this priority.  You want to be higher or lower.
*/


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
    get { return translatesAutoresizingMaskIntoConstraints() }
    set { setTranslatesAutoresizingMaskIntoConstraints(newValue) }
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
      var rv: UIView? = nil
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

