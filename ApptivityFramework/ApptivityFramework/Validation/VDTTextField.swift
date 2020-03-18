//
//  VDTTextField.swift
//  ApptivityFramework
//
//  Created by Jason Khong on 11/21/16.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

@IBDesignable
public class VDTTextField: UITextField {
    // MARK: IBInspectables
    @IBInspectable override public var text: String? {
        didSet {
            self.updateErrorLabel()
        }
    }
    
    @IBInspectable public var leftImage: UIImage? = nil {
        didSet {
            if let image = self.leftImage {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                
                if let size = imageView.image?.size {
                    imageView.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 20.0, height: size.height)
                }

                self.leftView = imageView
                self.leftViewMode = .always
            }
        }
    }
    
    @IBInspectable public var rightButtonImage: UIImage? = nil {
        didSet {
            if let image = self.rightButtonImage {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                
                if let size = imageView.image?.size {
                    imageView.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 20, height: size.height)
                }
                
                self.rightButton = UIButton(frame: imageView.frame)
                self.rightButton?.setImage(image, for: .normal)
                
                self.rightView = self.rightButton
                self.rightViewMode = .always
            }
        }
    }
    
    @IBInspectable public var selectedRightButtonImage: UIImage? = nil {
        didSet {
            if let image = self.selectedRightButtonImage {
                
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                
                if let size = imageView.image?.size {
                    imageView.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 20, height: size.height)
                }

                self.rightButton?.setImage(image, for: .selected)
            }
        }
    }
    
    @IBInspectable public var suffix: String? = nil {
        didSet {
            self.setNeedsDisplay()
        }
    }

    @IBInspectable public var floatingLabelTextColor: UIColor = .lightGray {
        didSet {
            self.updateColors()
        }
    }
    
    @IBInspectable var showLineView: Bool = false {
        didSet {
            self.updateLineView()
        }
    }
    
    @IBInspectable public var lineHeight: CGFloat = 1.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var lineViewColor: UIColor = .lightGray {
        didSet {
            self.updateColors()
        }
    }
    
    @IBInspectable public var helperText: String? = nil {
        didSet {
            self.updateErrorLabel()
        }
    }
    
    @IBInspectable public var helperLabelTextColor: UIColor = .lightGray {
        didSet {
            self.updateColors()
        }
    }
    
    @IBInspectable public var errorLabelTextColor: UIColor = .red {
        didSet {
            self.updateColors()
        }
    }
    
    // MARK: Declared variables
    public var rulesMapping: [(rule: (_ text: String) -> Bool, errorMessage: String)] = []
    
    public var isInputTextValid: Bool {
        let rules = self.rulesMapping.map { $0.rule }
        self.validate()
        return rules.reduce(true) { $0 && $1(self.inputText) }
    }
    
    override public var isSecureTextEntry: Bool {
        didSet {
            let originalText = self.text
            self.text = String()
            self.text = originalText
        }
    }
    
    public var inputText: String {
        get {
            return self.text ?? ""
        }
    }
    
    private var floatingLabel: UILabel!
    private var lineView: UIView!
    private var errorLabel: UILabel!
    private var helperLabel: UILabel!
    public var rightButton: UIButton?
    
    static private let animationDuration: TimeInterval = 0.3
    
    private var isInitialized: Bool = false
    private var leftViewWidth: CGFloat {
        return self.leftView?.frame.size.width ?? 0
    }
    
    private var floatingLabelHeight: CGFloat {
        if let floatingLabel = self.floatingLabel, let font = floatingLabel.font {
            return font.lineHeight
        }
        
        return 15.0
    }
    
    private var errorLabelHeight: CGFloat {
        if let errorLabel = self.errorLabel, let font = errorLabel.font {
            return font.lineHeight
        }
        
        return 15.0
    }
    
    private var helperLabelHeight: CGFloat {
        if !(self.helperText ?? "").isEmpty, let font = self.helperLabel.font {
            return font.lineHeight
        }
        
        return 15.0
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.instantiateViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.instantiateViews()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.lineView.frame = CGRect(x: 0, y: self.bounds.size.height - self.lineHeight - self.errorLabelHeight, width: self.bounds.width, height: self.lineHeight)
        self.errorLabel.frame = CGRect(x: 0, y: self.bounds.size.height - self.errorLabelHeight, width: self.bounds.width, height: self.errorLabelHeight)
        self.helperLabel.frame = CGRect(x: 0, y: self.bounds.size.height - self.helperLabelHeight, width: self.bounds.width, height: self.helperLabelHeight)
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        // Only draw suffix when we have a suffix and a text
        if (suffix ?? "").isEmpty == false && inputText.isEmpty == false {
            
            // We use some handy methods on NSString
            let text = inputText as NSString
            
            // The x position of the suffix
            var suffixXPosition: CGFloat = self.leftViewWidth
            
            // Font and color for the suffix
            let color = self.textColor ?? self.floatingLabelTextColor
            let attrs:[NSAttributedStringKey : Any] = [NSAttributedStringKey.font: self.font!, NSAttributedStringKey.foregroundColor: color]
            
            // Calc the x position of the suffix
            if textAlignment == .center {
                let fieldWidth = frame.size.width
                let textWidth = text.size(withAttributes: attrs).width
                suffixXPosition = (fieldWidth / 2) + (textWidth / 2)
            } else {
                suffixXPosition += text.size(withAttributes: attrs).width
            }
            
            // Calc the rect to draw the suffix in
            let height = text.size(withAttributes: attrs).height
            let top: CGFloat = 17
            let width = (suffix! as NSString).size(withAttributes: attrs).width
            let rect = CGRect(x: suffixXPosition, y: top, width: width, height: height)
            
            // Draw it
            (self.suffix! as NSString).draw(in: rect, withAttributes: attrs)
        }
    }
    
    private func instantiateViews() {
        self.createFloatingLabel()
        self.createLineView()
        self.createErrorLabel()
        self.createHelperLabel()
        
        self.isInitialized = true
        self.addTarget(self, action: #selector(VDTTextField.updateFloatLabelHighlight), for: UIControlEvents.editingDidBegin)
        self.addTarget(self, action: #selector(VDTTextField.updateFloatLabelHighlight), for: UIControlEvents.editingChanged)
        self.addTarget(self, action: #selector(VDTTextField.updateErrorLabel), for: UIControlEvents.editingDidEnd)
    }
    
    // MARK: Instantiation
    private func createFloatingLabel() {
        if self.floatingLabel == nil {
            self.floatingLabel = UILabel(frame: CGRect(x: self.leftViewWidth, y: 20, width: self.bounds.width, height: 13))
            self.floatingLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
            self.floatingLabel.alpha = 0.0
            self.addSubview(self.floatingLabel)
        }
        
        self.floatingLabel.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    }
    
    private func createLineView() {
        if self.lineView == nil {
            self.lineView = UIView(frame: CGRect(x: 0, y: self.bounds.height - self.lineHeight, width: self.bounds.width, height: self.lineHeight))
            self.lineView.backgroundColor = self.lineViewColor
            self.addSubview(self.lineView)
        }
        
        self.lineView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    }
    
    private func createErrorLabel() {
        if self.errorLabel == nil {
            self.errorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 13))
            self.errorLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
            self.errorLabel.alpha = 0.0
            self.addSubview(self.errorLabel)
        }
        
        self.errorLabel.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    }
    
    private func createHelperLabel() {
        if self.helperLabel == nil {
            self.helperLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 13))
            self.helperLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
            self.helperLabel.alpha = 1.0
            self.addSubview(self.helperLabel)
        }
        
        self.helperLabel.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    }
    
    // MARK: - Validation
    @objc
    private func validate() {
        for (rule, errorMessage) in self.rulesMapping {
            if !rule(self.inputText) {
                self.showErrorLabel(withText: errorMessage)
                return
            }
        }
        
        self.hideErrorLabel()
    }
    
    // MARK: - Update display
    @objc func updateFloatLabelHighlight() {
        self.floatingLabel.isHighlighted = self.isFirstResponder
        self.floatingLabel.highlightedTextColor = self.tintColor
        self.floatingLabel.textColor = self.floatingLabelTextColor
        self.lineView.backgroundColor = self.isFirstResponder ? self.tintColor : self.lineViewColor

        self.helperLabel.text = self.helperText
        self.floatingLabel.text = self.placeholder
        
        if !self.inputText.isEmpty {
            self.showFloatingLabel()
        } else {
            self.hideFloatingLabel()
        }

        self.hideErrorLabel()
    }
    
    private func updateColors() {
        if !self.isInitialized {
            return
        }
        
        self.floatingLabel.textColor = self.isInputTextValid ? self.floatingLabelTextColor : self.errorLabelTextColor
        self.floatingLabel.highlightedTextColor = self.isInputTextValid ? self.tintColor : self.errorLabelTextColor
        self.helperLabel.textColor = self.helperLabelTextColor
        self.lineView.backgroundColor = self.lineViewColor
        self.errorLabel.textColor = self.errorLabelTextColor
    }
    
    @objc
    private func updateErrorLabel() {
        if !self.isInitialized {
            return
        }
        
        self.helperLabel.text = self.helperText
        self.floatingLabel.text = self.placeholder
        self.floatingLabel.isHighlighted = self.isFirstResponder
        self.updateColors()
        
        if !self.inputText.isEmpty {
            self.showFloatingLabel()
        } else {
            self.hideFloatingLabel()
        }
        
        self.updateLineView()
        self.validate()
    }
    
    private func updateLineView() {
        if !self.isInitialized {
            return
        }
        
        self.lineView.isHidden = !self.showLineView
        if self.isInputTextValid {
            self.lineView.backgroundColor = self.isFirstResponder ? self.tintColor : self.lineViewColor
        } else {
            self.lineView.backgroundColor = self.errorLabelTextColor
        }
    }
    
    private func showFloatingLabel() {
        let labelShownFrame = CGRect(x: self.leftViewWidth, y: 0, width: self.frame.width, height: 13)
        UIView.animate(withDuration: VDTTextField.animationDuration,
                       delay: 0.0,
                       options: .curveEaseIn,
                       animations: {
                        self.floatingLabel.alpha = 1.0
                        self.floatingLabel.frame = labelShownFrame
        },
                       completion: nil)
    }
    
    private func hideFloatingLabel() {
        let yOffset: CGFloat = (self.bounds.size.height - self.floatingLabelHeight) / 2
        let labelHiddenFrame = CGRect(x: self.leftViewWidth, y: yOffset, width: self.frame.width, height: 13)
        
        UIView.animate(withDuration: VDTTextField.animationDuration,
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        self.floatingLabel.alpha = 0.0
                        self.floatingLabel.frame = labelHiddenFrame
        },
                       completion: nil)
    }

    public func showErrorLabel(withText text: String) {
        self.errorLabel.text = text
        let labelShownFrame = CGRect(x: self.leftViewWidth, y: self.bounds.height - self.errorLabelHeight, width: self.bounds.width, height: self.errorLabelHeight)
        self.helperLabel.alpha = 0.0

        UIView.animate(withDuration: VDTTextField.animationDuration,
                       delay: 0.0,
                       options: .curveEaseIn,
                       animations: {

                        self.errorLabel.alpha = 1.0
                        self.errorLabel.frame = labelShownFrame
        },
                       completion: nil)
    }
    
    private func hideErrorLabel() {
        if self.errorLabel.alpha == 0.0 {
            return
        }
        
        let yOffset: CGFloat = (self.bounds.height - self.errorLabelHeight) / 2
        let labelHiddenFrame = CGRect(x: self.leftViewWidth, y: yOffset, width: self.bounds.width, height: 13)
        self.errorLabel.alpha = 0.0

        UIView.animate(withDuration: VDTTextField.animationDuration,
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        self.errorLabel.frame = labelHiddenFrame
                        self.helperLabel.alpha = 1.0
        },
                       completion: nil)
    }
    
    // MARK :- Text Rect Management
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        
        return CGRect(
            x: self.leftViewWidth,
            y: self.floatingLabelHeight,
            width: superRect.size.width,
            height: superRect.size.height - self.floatingLabelHeight - self.lineHeight - self.errorLabelHeight
        )
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        
        return CGRect(
            x: self.leftViewWidth,
            y: self.floatingLabelHeight,
            width: superRect.size.width,
            height: superRect.size.height - self.floatingLabelHeight - self.lineHeight - self.errorLabelHeight
        )
    }
    
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        
        return CGRect(
            x: self.leftViewWidth,
            y: self.floatingLabelHeight,
            width: superRect.size.width,
            height: superRect.size.height - self.floatingLabelHeight - self.lineHeight - self.errorLabelHeight
        )
    }
}
