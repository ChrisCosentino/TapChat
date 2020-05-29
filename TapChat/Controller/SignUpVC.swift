//
//  SignUpVC.swift
//  ExHiBit
//
//  Created by Chris Cosentino on 2019-05-22.
//  Copyright © 2019 Chris Cosentino. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: MaterialFormTextField!
    @IBOutlet weak var passwordTF: MaterialFormTextField!
    @IBOutlet weak var usernameTF: MaterialFormTextField!
    @IBOutlet weak var datePick: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        passwordTF.delegate = self
        usernameTF.delegate = self
        datePick.maximumDate = Date()
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        let email = emailTF.text
        let password = passwordTF.text
        let username = usernameTF.text

        if email != "" && password != "" && username != ""{ //Text fields are all filled in
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(username!)
            docRef.getDocument { (snapshot, error) in
                if snapshot!.exists{//Username already exists
                    self.showError(err: "Username already exists please enter a new one")
                    self.usernameTF.text = ""
                }else{//The username is unique
                    Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
                        if error != nil{ //If an error is found
                            if let errCode = AuthErrorCode(rawValue: error!._code){
                                switch errCode{
                                case .invalidEmail:
                                    self.showError(err: "Invalid email")
                                case .emailAlreadyInUse:
                                    self.showError(err: "Email already in use")
                                case .weakPassword:
                                    self.showError(err: "Weak Password")
                                default: //some other error
                                    self.showError(err: "Internal Error")
                                }
                            }
                        }else{// No error is found with the auth, set the data in database
                            Firestore.firestore().collection("users").document(username!).setData([
                                "provider": "email",
                                "username": username!,
                                "email": user?.user.email!,
                                "uid": user?.user.uid,
                            ]) { err in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                    self.showError(err: "Error adding document: \(err)")
                            } else {
                                // print("Document added with ID: \(ref!.documentID)")
                                print("Document added!")
                                //segue to next screen
                                self.performSegue(withIdentifier: "SEGUE_LOGGED_IN", sender: self)
                                    }
                            }
                        }
                    })
                }
            }
        }else{//Text fields are not filled in
            self.showError(err: "Please fill in all fields")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case emailTF:
            passwordTF.becomeFirstResponder()
        case passwordTF:
            usernameTF.becomeFirstResponder()
        case usernameTF:
            textField.resignFirstResponder()
        default:
           textField.resignFirstResponder()
        }
        return false
    }
    
    func showError(err: String){
        let alert = UIAlertController(title: "Error", message: err, preferredStyle: .alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

extension SignUpVC{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Verify all the conditions
        if let sdcTextField = textField as? MaxLengthTextField {
            return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
        }
        return true
    }
}
