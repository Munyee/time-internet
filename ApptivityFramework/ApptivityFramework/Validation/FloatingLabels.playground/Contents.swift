////: Playground - noun: a place where people can play
//
//import UIKit
//import XCPlayground
//
//class VDTTextField: UITextField {
//    static let animationDuration: TimeInterval = 0.3
//    let labelHiddenYOffset: CGFloat = 4
//    
//    var floatLabel: UILabel!
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//    
//    func setup() {
//        self.floatLabel = UILabel(frame: CGRect(x: 0, y: labelHiddenYOffset, width: self.frame.width, height: 12))
//        self.floatLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
//        self.floatLabel.alpha = 0.0
//        self.floatLabel.textColor = UIColor.lightGray
//        self.floatLabel.highlightedTextColor = self.tintColor ?? UIColor.blue
//        
//        self.addSubview(self.floatLabel)
//        
//        self.addTarget(self, action: #selector(VDTTextField.updateLabel), for: UIControlEvents.editingChanged)
//        self.addTarget(self, action: #selector(VDTTextField.updateFloatLabelHighlight), for: UIControlEvents.editingDidBegin)
//        self.addTarget(self, action: #selector(VDTTextField.updateFloatLabelHighlight), for: UIControlEvents.editingDidEnd)
//    }
//    
//    func updateLabel() {
//        self.floatLabel.text = self.placeholder
//        
//        if (self.text?.characters.count)! > 0 {
//            showFloatLabel()
//        } else {
//            hideFloatLabel()
//        }
//    }
//    
//    func showFloatLabel() {
//        let labelShownFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: 17)
//        UIView.animate(withDuration: VDTTextField.animationDuration,
//                       delay: 0.0,
//                       options: .curveEaseIn,
//                       animations: {
//                            self.floatLabel.alpha = 1.0
//                            self.floatLabel.frame = labelShownFrame
//                       },
//                       completion: nil)
//    }
//    
//    func hideFloatLabel() {
//        let labelHiddenFrame = CGRect(x: 0, y: labelHiddenYOffset, width: self.frame.width, height: 17)
//
//        UIView.animate(withDuration: VDTTextField.animationDuration,
//                       delay: 0.0,
//                       options: .curveEaseOut,
//                       animations: {
//                            self.floatLabel.alpha = 0.0
//                            self.floatLabel.frame = labelHiddenFrame
//                       },
//                       completion: nil)
//    }
//    
//    func updateFloatLabelHighlight() {
//        self.floatLabel.isHighlighted = self.isFirstResponder
//    }
//}
//
//var view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//XCPlaygroundPage.currentPage.liveView = view
//
//var textField: VDTTextField = VDTTextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
//textField.backgroundColor = UIColor.white
//textField.placeholder = "hello world"
//view.addSubview(textField)
//
//var textField2: VDTTextField = VDTTextField(frame: CGRect(x: 0, y: 51, width: 200, height: 100))
//textField2.backgroundColor = UIColor.white
//textField2.placeholder = "hello again"
//view.addSubview(textField2)
//
//var str = "Hello, playground"
