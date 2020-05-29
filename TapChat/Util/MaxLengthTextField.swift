//
//  MaxTextFieldLength.swift
//  TapChat
//
//  Created by Chris Cosentino on 2019-08-17.
//  Copyright © 2019 Chris Cosentino. All rights reserved.
//
import UIKit
import Foundation

enum ValueType: Int {
    case none
    case onlyLetters
    case onlyNumbers
    case phoneNumber   // Allowed "+0123456789"
    case alphaNumeric
    case fullName       // Allowed letters and space
}

class MaxLengthTextField: UITextField, UITextFieldDelegate {
//
//    private var characterLimit: Int?
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        delegate = self
//    }
    @IBInspectable var maxLength: Int = 0 // Max character length
    var valueType: ValueType = ValueType.none // Allowed characters
    
    /************* Added new feature ***********************/
    // Accept only given character in string, this is case sensitive
    @IBInspectable var allowedCharInString: String = ""
    
    override func awakeFromNib() {
        layer.cornerRadius = 5.0

        //Adds indentation to begining of textfield
        let leftPadding = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 2.0))
        leftView = leftPadding
        leftViewMode = .always
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let maxLength = 5
//        let currentString: NSString = textField.text! as NSString
//        let newString: NSString =
//            currentString.replacingCharacters(in: range, with: string) as NSString
//        return newString.length <= maxLength
//    }
//
//    @IBInspectable var maxLength: Int {
//        get {
//            guard let length = characterLimit else {
//                return Int.max
//            }
//            return length
//        }
//        set {
//            characterLimit = newValue
//        }
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        guard string.count > 0 else {
//            return true
//        }
//
//        let currentText = textField.text ?? ""
//        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
//
//        // 1. Here's the first change...
//        return allowedIntoTextField(text: prospectiveText)
//    }
//
//    // 2. ...and here's the second!
//    func allowedIntoTextField(text: String) -> Bool {
//        return text.count <= maxLength
//    }

    func verifyFields(shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch valueType {
        case .none:
            break // Do nothing
            
        case .onlyLetters:
            let characterSet = CharacterSet.letters
            if string.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }
            
        case .onlyNumbers:
            let numberSet = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: numberSet.inverted) != nil {
                return false
            }
            
        case .phoneNumber:
            let phoneNumberSet = CharacterSet(charactersIn: "+0123456789")
            if string.rangeOfCharacter(from: phoneNumberSet.inverted) != nil {
                return false
            }
            
        case .alphaNumeric:
            let alphaNumericSet = CharacterSet.alphanumerics
            if string.rangeOfCharacter(from: alphaNumericSet.inverted) != nil {
                return false
            }
            
        case .fullName:
            var characterSet = CharacterSet.letters
            print(characterSet)
            characterSet = characterSet.union(CharacterSet(charactersIn: " "))
            if string.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }
        }
        
        if let text = self.text, let textRange = Range(range, in: text) {
            let finalText = text.replacingCharacters(in: textRange, with: string)
            if maxLength > 0, maxLength < finalText.utf8.count {
                return false
            }
        }
        
        // Check supported custom characters
        if !self.allowedCharInString.isEmpty {
            let customSet = CharacterSet(charactersIn: self.allowedCharInString)
            if string.rangeOfCharacter(from: customSet.inverted) != nil {
                return false
            }
        }
        
        return true
    }
}
