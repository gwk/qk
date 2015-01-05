// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias LOP = NSLayoutPriority
  //let LOPReq = NSLayoutPriorityRequired // TODO: swift 1.1 omits the 'static' storage type, causing linker error.
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
  //let LOPReq = UILayoutPriorityRequired // TODO: swift 1.1 omits the 'static' storage type, causing linker error.
  let LOPReq = LOP(1000)
  let LOPHigh = LOP(750)
  let LOPLow = LOP(250)
  let LOPFit = LOP(50)
#endif


struct QKLayoutOperand {
  // a layout operand represents one side of a constraint: a view and an attribute, or a pair of attributes for 2D constraints.
  let v: CRView
  let a0: NSLayoutAttribute
  let a1: NSLayoutAttribute
}


extension CRView {
  
  func _loOper(a0: NSLayoutAttribute, _ a1: NSLayoutAttribute = .NotAnAttribute) -> QKLayoutOperand {
    return QKLayoutOperand(v: self, a0: a0, a1: a1)
  }
  
  // layout operand properties.
  
  var l: QKLayoutOperand { return _loOper(.Left) }
  var r: QKLayoutOperand { return _loOper(.Right) }
  var t: QKLayoutOperand { return _loOper(.Top) }
  var b: QKLayoutOperand { return _loOper(.Bottom) }
  
  var cx: QKLayoutOperand { return _loOper(.CenterX) }
  var cy: QKLayoutOperand { return _loOper(.CenterY) }
  
  var lt: QKLayoutOperand { return _loOper(.Left, .Top) }
  var lc: QKLayoutOperand { return _loOper(.Left, .CenterY) }
  var lb: QKLayoutOperand { return _loOper(.Left, .Bottom) }
  var ct: QKLayoutOperand { return _loOper(.CenterX, .Top) }
  var c: QKLayoutOperand { return _loOper(.CenterX, .CenterY) }
  var cb: QKLayoutOperand { return _loOper(.CenterX, .Bottom) }
  var rt: QKLayoutOperand { return _loOper(.Right, .Top) }
  var rc: QKLayoutOperand { return _loOper(.Right, .CenterY) }
  var rb: QKLayoutOperand { return _loOper(.Right, .Bottom) }
  
  var lead: QKLayoutOperand { return _loOper(.Leading) }
  var trail: QKLayoutOperand { return _loOper(.Trailing) }
  
  var w: QKLayoutOperand { return _loOper(.Width) }
  var h: QKLayoutOperand { return _loOper(.Height) }
  var s: QKLayoutOperand { return _loOper(.Width, .Height) }
  
  var base: QKLayoutOperand { return _loOper(.Baseline) }
  
  var usesARMask: Bool {
    // abbreviated, crossplatform property.
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


#if os(iOS)
extension UIViewController {
  // expose the layoutGuide properties as UIView instances so that they can be used by QKLayoutOperand;
  // formulating QKLayoutOperand in terms of protocols including UILayoutSupport protocol is not possible in swift 1.1.
  var tg: UIView {
    let a: AnyObject = topLayoutGuide
    return a as UIView // this cast works in ios 8, not guaranteed to work in the future.

  }
  var bg: UIView {
    let a: AnyObject = bottomLayoutGuide
    return a as UIView // this cast works in ios 8, not guaranteed to work in the future.
  }
}
#endif


protocol QKLayoutConstraining {
  // protocol implemented for NSLayoutConstraint, String (visual format strings), and QKLayoutRel.
  // allows for constraints and format strings to be specified in the same variadic call;
  // this is syntactically convenient, and also allows for simultaneous activation of all constraints,
  // which is more performant, according to the comments around NSLayoutConstraint.activateConstraints.
  func constraintArray(views: [CRView], metrics: [String: NSNumber], opts: NSLayoutFormatOptions) -> [NSLayoutConstraint]
}


extension NSLayoutConstraint: QKLayoutConstraining {
  
  var lv: CRView { return firstItem as CRView }
  var la: NSLayoutAttribute { return firstAttribute }
  var rv: CRView? { return secondItem as CRView? }
  var ra: NSLayoutAttribute { return secondAttribute }
  
  convenience init(_ rel: NSLayoutRelation, _ l: QKLayoutOperand, _ r: QKLayoutOperand?, _ m: Flt, _ c: Flt, _ p: LOP, useA1: Bool) {
    // convenience constructor for QKLayoutRel; create a constraint from either a0 or a1 af a pair of operands.
    // useA1 is true only when a second attribute is provided by 2D operands.
    let la = useA1 ? l.a1 : l.a0
    assert(la != .NotAnAttribute)
    var rv: CRView? = nil
    var ra = NSLayoutAttribute.NotAnAttribute
    if let _r = r {
      rv = _r.v
      ra = useA1 ? _r.a1 : _r.a0
      assert(ra != .NotAnAttribute)
    }
    self.init(item: l.v, attribute: la, relatedBy: rel, toItem: rv, attribute: ra, multiplier: m,  constant: c)
    priority = p
  }
  
  func constraintArray(views: [CRView], metrics: [String: NSNumber], opts: NSLayoutFormatOptions) -> [NSLayoutConstraint] {
    // this is only useful for passing a manually constructed constraint as an argument to constrain().
    return [self] // ignore all the format-related arguments.
  }
}


extension String: QKLayoutConstraining {
  
  func constraintArray(views: [CRView], metrics: [String: NSNumber], opts: NSLayoutFormatOptions) -> [NSLayoutConstraint] {
    let viewDict = mapToDict(views) { ($0.name, $0) }
    return NSLayoutConstraint.constraintsWithVisualFormat(self, options: opts, metrics: metrics, views: viewDict) as [NSLayoutConstraint]
  }
}


// MARK: layout relations.

struct QKLayoutRel: QKLayoutConstraining {
  let rel: NSLayoutRelation
  let l: QKLayoutOperand
  let r: QKLayoutOperand? = nil
  let m: Flt = 1
  let c: Flt = 0
  // TODO: m1, c1 corresponding to a1.
  let p: LOP = LOPReq
  
  func constraintArray(views: [CRView], metrics: [String: NSNumber], opts: NSLayoutFormatOptions) -> [NSLayoutConstraint] {
    // ignores all the format-related arguments and constructs one or two constraints from the operands.
    let c0 = NSLayoutConstraint(rel, l, r, m, c, p, useA1: false)
    if l.a1 != .NotAnAttribute {
      let c1 = NSLayoutConstraint(rel, l, r, m, c, p, useA1: true)
      return [c0, c1]
    } else {
      return [c0]
    }
  }

}

func eq(l: QKLayoutOperand, _ r: QKLayoutOperand? = nil, m: Flt = 1, c: Flt = 0, p: LOP = LOPReq) -> QKLayoutRel {
  // construct an equality relation between two operands.
  return QKLayoutRel(rel: .Equal, l: l, r: r, m: m, c: c, p: p)
}

// TODO: lt, gt, le, ge.


// MARK: constrain variants.

func constrain(views: [CRView], metrics: [String: NSNumber] = [:], opts: NSLayoutFormatOptions = NSLayoutFormatOptions(0), #constraints: [QKLayoutConstraining]) {
  // main variant.
  for v in views {
    v.usesARMask = false
  }
  var allConstraints: [NSLayoutConstraint] = []
  for c in constraints {
    allConstraints.extend(c.constraintArray(views, metrics: metrics, opts: opts))
  }
  NSLayoutConstraint.activateConstraints(allConstraints)
}

func constrain(views: [CRView], metrics: [String: NSNumber] = [:], opts: NSLayoutFormatOptions = NSLayoutFormatOptions(0), constraints: QKLayoutConstraining...) {
  // variadic variant.
  constrain(views, metrics: metrics, opts: opts, constraints: constraints)
}

