//
//  Validation.swift
//  ApptivityFramework
//
//  Created by Jason Khong on 11/21/16.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

struct ValidationError: Error {
    enum ErrorType {
        case required
        case invalid
    }
    
    let field: String?
    let kind: ErrorType
    
    var localizedDescription: String {
        get {
            switch kind {
            case .required:
                return "\(String(describing: field)) is required"
            default:
                return "\(String(describing: field)) is invalid"
            }
        }
    }
}

protocol Validator {
    var fieldName: String {get}
    var isRequired: Bool {get set}
    
    func checkErrors() -> Error?
}

protocol TextValidator: Validator {
    var inputText: String {get}
    
    var maxLength: Int {get set}
    var isEmail: Bool {get set}
    var isIntegerOnly: Bool {get set}
}

extension TextValidator {
    func passRequired() throws {
        if isRequired {
            if inputText.count == 0 {
                throw ValidationError(field: fieldName, kind: .required)
            }
        }
    }
    
    func passMaximumCharacters() throws {
        if inputText.count > maxLength {
            throw ValidationError(field: fieldName, kind: .invalid)
        }
    }
    
    func passEmailRegex() throws {
        if isEmail {
            let email: String = inputText
            let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            let valid: Bool =  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
            if !valid {
                throw ValidationError(field: fieldName, kind: .invalid)
            }
        }
    }
    
    func passIntegerOnly() throws {
        if isIntegerOnly {
            let intValue: Int? = Int(inputText)
            if intValue == nil {
                throw ValidationError(field: fieldName, kind: .invalid)
            }
        }
    }

    func checkErrors() -> Error? {
        do {
            try passRequired()
            try passMaximumCharacters()
            try passEmailRegex()
            try passIntegerOnly()
        } catch {
            return error
        }
        
        return nil
    }
}

@IBDesignable
class ValidateTextView: UITextView, TextValidator {
    var fieldName: String {
        get {
            return self.placeholder
        }
    }
    var inputText: String {
        get {
            return self.text
        }
    }

    @IBInspectable var placeholder: String = ""
    @IBInspectable var isRequired: Bool = false
    @IBInspectable var maxLength: Int = 0
    @IBInspectable var isEmail: Bool = false
    @IBInspectable var isIntegerOnly: Bool = false
}

@IBDesignable
class ValidateTextField: UITextField, TextValidator {
    var fieldName: String {
        get {
            return self.placeholder ?? ""
        }
    }

    var inputText: String {
        get {
            return self.text ?? ""
        }
    }
    
    @IBInspectable var isRequired: Bool = false
    @IBInspectable var maxLength: Int = 0
    @IBInspectable var isEmail: Bool = false
    @IBInspectable var isIntegerOnly: Bool = false
}

extension UIViewController {
    func validateInputs() {
        // Check self.view, displays an error if ANY of the inputs are not valid
    }
}
