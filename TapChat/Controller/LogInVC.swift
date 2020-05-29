//
//  LogInVC.swift
//  ExHiBit
//
//  Created by Chris Cosentino on 2019-05-22.
//  Copyright © 2019 Chris Cosentino. All rights reserved.
//

import UIKit
import Firebase

class LogInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: MaterialFormTextField!
    @IBOutlet weak var passwordTF: MaterialFormTextField!
    
    var username: String = ""
    var current: CurrentUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        passwordTF.delegate = self
        // Do any additional setup after loading the view.
        
      
      //  UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                // user is signed in
                // go to feature controller
                self.performSegue(withIdentifier: "SEGUE_LOGGED_IN", sender: self)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    //Moves the current textfield to the next one when return button pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTF:
            passwordTF.becomeFirstResponder()
        case passwordTF:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
    //Set max length of textfield strings
 
    
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
        let email = emailTF.text!
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let err = error{
                //An error was found
                self.showError(err: "Please enter a valid email in the email field and click 'forgot password' again")
            }
        }
    }
    
    @IBAction func logInBtnPressed(_ sender: Any) {
        let email = emailTF.text
        let password = passwordTF.text
        
        if email != "" && password != ""{ //Email and password fields are not empty
            
            Auth.auth().signIn(withEmail: email!, password: password!, completion: ({ (user, error) in
                if error != nil{ // error is found
                    if let errCode = AuthErrorCode(rawValue: error!._code){
                        switch errCode{
                        case .invalidEmail:
                            
                            self.showError(err: "Invalid email")
                        case .wrongPassword:
                            
                            self.showError(err: "incorrect password")
                        case .userNotFound:
                            self.showError(err: "account does not exist")
                        default:
                            self.showError(err: "Internal error")
                        }
                    }
                }else{
                    //No error is found
                    //Segue to next screen
                    print("success")
                    print(Auth.auth().currentUser?.uid)
                    self.performSegue(withIdentifier: "SEGUE_LOGGED_IN", sender: self)
                }
                
            }))
        }else{ //One of the fields is empty
            self.showError(err: "Please fill in all fields and try again")
        }
    }
    
    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func showError(err: String){
        let alert = UIAlertController(title: "Error", message: err, preferredStyle: .alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
