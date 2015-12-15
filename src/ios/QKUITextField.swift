// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


var stdTextFieldColor = CRColor.w
var stdTextFieldTextColor = CRColor(l: 0.1)
var stdTextFieldFont = UIFont.systemFontOfSize(16)
var stdTextFieldCornerRadius: Flt = 4
var stdTextFieldInset: V2 = V2(8 ,8)

class QKUITextField: UITextField, UITextFieldDelegate {
  var shouldBegin: Predicate = always
  var didBegin: Action = {}
  var shouldEnd: Predicate = always
  var didEnd: Action = {}
  var shouldChange: (NSRange, String) -> Bool = { (r, s) in return true }
  var shouldClear: Predicate = always
  var shouldReturn: Predicate = always
  var textInset: V2 = V2(0, 0)
  
  // MARK: - UIView
  
  required init(coder: NSCoder) { fatalError() }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    helpInit()
    backgroundColor = stdTextFieldColor
    textColor = stdTextFieldTextColor
    font = stdTextFieldFont
    layer.cornerRadius = stdTextFieldCornerRadius
    textInset = stdTextFieldInset
  }
  
  convenience init(n: String, p: UIView?, placeholder: String? = nil) {
    self.init(frame: frameInit)
    helpInit(name: n, parent: p)
    self.placeholder = placeholder
  }
  
  // MARK: UITextField
  
  override func textRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectInset(bounds, textInset.x, textInset.y)
  }
  
  override func editingRectForBounds(bounds: CGRect) -> CGRect {
    // TODO: the default accounts for overlay rectangles; handling of this case has not been tested.
    return CGRectIntersection(super.editingRectForBounds(bounds), self.textRectForBounds(bounds))
  }
  // MARK: QKUITextField
  
  func helpInit() {
    delegate = self
  }
  
  func setNext(nextControl: UIControl) {
    returnKeyType = .Next
    shouldReturn = {
      nextControl.becomeFirstResponder()
      return true
    }
  }

  
  // MARK: UITextFieldDelegate
  
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool { return shouldBegin() }
  
  func textFieldDidBeginEditing(textField: UITextField) { didBegin() }

  func textFieldShouldEndEditing(textField: UITextField) -> Bool { return shouldEnd() }
  
  func textFieldDidEndEditing(textField: UITextField) { didEnd() }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    return shouldChange(range, string)
  }

  func textFieldShouldClear(textField: UITextField) -> Bool { return shouldClear() }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool { return shouldReturn() }
}

