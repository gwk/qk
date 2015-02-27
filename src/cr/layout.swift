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
  // a layout operand represents one side of a constraint: a view and an X,Y pair of attributes;
  // many relations will only express an attribute in one dimension.
  let v: CRView
  let ax: NSLayoutAttribute
  let ay: NSLayoutAttribute
  
  var componentCount: Int { return (ax.isSome ? 1 : 0) + (ay.isSome ? 1 : 0) }
}


extension CRView {
  
  // layout operand properties.
  
  var l: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .Left, ay: .NotAnAttribute) }
  var r: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .Right, ay: .NotAnAttribute) }
  var t: QKLayoutOperand { return QKLayoutOperand(v: self, ax:  .NotAnAttribute, ay: .Top) }
  var b: QKLayoutOperand { return QKLayoutOperand(v: self, ax:  .NotAnAttribute, ay: .Bottom) }
  
  var x: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .CenterX, ay: .NotAnAttribute) }
  var y: QKLayoutOperand { return QKLayoutOperand(v: self, ax:  .NotAnAttribute, ay: .CenterY) }
  
  var lt: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .Left, ay: .Top) }
  var ly: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .Left, ay: .CenterY) }
  var lb: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .Left, ay: .Bottom) }
  var xt: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .CenterX, ay: .Top) }
  var xy: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .CenterX, ay: .CenterY) }
  var xb: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .CenterX, ay: .Bottom) }
  var rt: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .Right, ay: .Top) }
  var ry: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .Right, ay: .CenterY) }
  var rb: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .Right, ay: .Bottom) }
  
  var lead: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .Leading, ay:  .NotAnAttribute) }
  var trail: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .Trailing, ay: .NotAnAttribute) }
  
  var w: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .Width, ay: .NotAnAttribute) }
  var h: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .NotAnAttribute, ay: .Height) }
  var wh: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .Width, ay: .Height) }
  
  var base: QKLayoutOperand { return QKLayoutOperand(v: self, ax: .Baseline, ay: .NotAnAttribute) }
  
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
    let v = a as UIView // this cast works in ios 8; not guaranteed to work in the future.
    v.name = "tg"
    return v
  }
  var bg: UIView {
    let a: AnyObject = bottomLayoutGuide
    let v = a as UIView // this cast works in ios 8; not guaranteed to work in the future.
    v.name = "bg"
    return v
  }
}
#endif


protocol QKLayoutConstraining {
  // protocol implemented for NSLayoutConstraint, String (visual format strings), and QKLayoutRel.
  // allows for constraints and format strings to be specified in the same variadic call;
  // this is syntactically convenient, and also allows for simultaneous activation of all constraints,
  // which is more performant according to the comments around NSLayoutConstraint.activateConstraints.
  func constraintArray(views: [CRView], metrics: [String: NSNumber], opts: NSLayoutFormatOptions) -> [NSLayoutConstraint]
}


extension NSLayoutConstraint: QKLayoutConstraining {
  
  var lv: CRView { return firstItem as! CRView }
  var la: NSLayoutAttribute { return firstAttribute }
  var rv: CRView? { return secondItem as! CRView? }
  var ra: NSLayoutAttribute { return secondAttribute }
  
  convenience init(rel: NSLayoutRelation, l: QKLayoutOperand, r: QKLayoutOperand?, m: V2, c: V2, p: LOP, useLX: Bool) {
    // convenience constructor for QKLayoutRel; create a constraint from either ax or ay of left side.
    let la = (useLX ? l.ax : l.ay)
    assert(la != .NotAnAttribute)
    var rv: CRView? = nil
    var ra = NSLayoutAttribute.NotAnAttribute
    var sm = useLX ? m.x : m.y
    var sc = useLX ? c.x : c.y
    if let r = r {
      assert(r.componentCount > 0) // ax or ay or both are acceptable.
      rv = r.v
      // choose the axis of r matching axis of l, or if it is not set, fall back on the alternate.
      var useRX = (useLX ? r.ax.isSome : !r.ay.isSome)
      ra = (useRX ? r.ax : r.ay)
    }
    self.init(item: l.v, attribute: la, relatedBy: rel, toItem: rv, attribute: ra, multiplier: sm,  constant: sc)
    priority = p
  }
  
  func constraintArray(views: [CRView], metrics: [String: NSNumber], opts: NSLayoutFormatOptions) -> [NSLayoutConstraint] {
    // this is only useful for passing a manually constructed constraint as an argument to constrain().
    return [self] // ignore all the format-related arguments.
  }
  
  class func eq(l: QKLayoutOperand, _ r: QKLayoutOperand? = nil, m: Flt = 1, c: Flt = 0, p: LOP = LOPReq) -> NSLayoutConstraint {
    // normally, the global functions below are used to construct one or two constraints at a time.
    // however, in the case where we want a handle on a particlur constraint for subsequent modification (e.g. for animation),
    // then use this function to construct exactly one constraint.
    assert(l.componentCount == 1)
    return NSLayoutConstraint(rel: NSLayoutRelation.Equal, l: l, r: r, m: V2(m, m), c: V2(c, c), p: p, useLX: l.ax.isSome)
  }
}


extension String: QKLayoutConstraining {
  
  func constraintArray(views: [CRView], metrics: [String: NSNumber], opts: NSLayoutFormatOptions) -> [NSLayoutConstraint] {
    let viewDict = mapToDict(views) { ($0.name, $0) }
    #if DEBUG // only use the wrapper method for debug.
      let m = NSLayoutConstraint.constraintsAndCatchWithVisualFormat
      #else
      let m = NSLayoutConstraint.constraintsWithVisualFormat
    #endif
    return m(self, options: opts, metrics: metrics, views: viewDict) as! [NSLayoutConstraint]
  }
}


// MARK: layout relations.

struct QKLayoutRel: QKLayoutConstraining {
  // a relation between two operands; this translates into one or two constraints,
  // depending on whether or not the left operand has two attributes.
  // NOTE: combinations with a single attribute on the left and two on the right are considered invalid (X,XY and Y,XY).
  // this is partly a stylistic choice; although the linear relations are themselves commutative,
  // we consider it good style to put a dependent operand on the left hand side;
  // in the case where an XY pair of attributes are related to a single X or Y, the pair must be dependent on the single.
  let rel: NSLayoutRelation
  let l: QKLayoutOperand
  let r: QKLayoutOperand? = nil
  let m: V2 = V2(1, 1)
  let c: V2 = V2(0, 0)
  let p: LOP = LOPReq
  
  func constraintArray(views: [CRView], metrics: [String: NSNumber], opts: NSLayoutFormatOptions) -> [NSLayoutConstraint] {
    // ignores all the format-related arguments and constructs one or two constraints from the operands.
    var leftCount = 0
    var rightCount = 0
    var constraints: [NSLayoutConstraint] = []
    assert(l.componentCount > 0)
    if l.componentCount == 1 && r != nil {
      assert(r!.componentCount < 2, "cannot relate a 1D operand on left to a 2D operand on right; if this relation is intentional, swap operands, rearranging m and c accordingly.")
    }
    if l.ax.isSome {
      constraints.append(NSLayoutConstraint(rel: rel, l: l, r: r, m: m, c: c, p: p, useLX: true))
    }
    if l.ay.isSome {
      constraints.append(NSLayoutConstraint(rel: rel, l: l, r: r, m: m, c: c, p: p, useLX: false))
    }
    return constraints
  }
}

func eq(l: QKLayoutOperand, _ r: QKLayoutOperand? = nil, m: V2 = V2(1, 1), c: V2 = V2(0, 0), p: LOP = LOPReq) -> QKLayoutRel {
  // construct an equality relation between two operands with vector m and c.
  return QKLayoutRel(rel: .Equal, l: l, r: r, m: m, c: c, p: p)
}

func eq(l: QKLayoutOperand, _ r: QKLayoutOperand? = nil, #m: Flt, c: Flt = 0, p: LOP = LOPReq) -> QKLayoutRel {
  // construct an equality relation between two operands with scalar m and optional c; m is required to disambiguate from the vector variant.
  return eq(l, r, m: V2(m, m), c: V2(c, c), p: p)
}

func eq(l: QKLayoutOperand, _ r: QKLayoutOperand? = nil, #c: Flt, p: LOP = LOPReq) -> QKLayoutRel {
  // construct an equality relation between two operands with scalar c; this variant is required to disambiguate from the vector variant.
  return eq(l, r, m: V2(1, 1), c: V2(c, c), p: p)
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
  #if DEBUG
    NSLayoutConstraint.activateAndCatchConstraints(allConstraints)
    #else
    NSLayoutConstraint.activateConstraints(allConstraints)
  #endif
}

func constrain(views: [CRView], metrics: [String: NSNumber] = [:], opts: NSLayoutFormatOptions = NSLayoutFormatOptions(0), constraints: QKLayoutConstraining...) {
  // variadic variant.
  constrain(views, metrics: metrics, opts: opts, constraints: constraints)
}

