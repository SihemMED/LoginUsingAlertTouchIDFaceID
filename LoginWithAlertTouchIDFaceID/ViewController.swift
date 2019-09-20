//
//  ViewController.swift
//  LoginWithAlertTouchIDFaceID
//
//  Created by Sihem Mohamed on 9/8/19.
//  Copyright © 2019 Sihem Mohamed. All rights reserved.
//

import UIKit
import LocalAuthentication // used for Touch ID, Face ID

class ViewController: UIViewController {
    
    
    @IBOutlet weak var loginFTIDButton: UIButton!
    var context = LAContext()
    var isFaceIDSupported = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkBiometryType()
    }
    
    @IBAction func loginWithAlertPressedButton(_ sender: Any) {
        loginWithAlert()
    }
    
    @IBAction func loginWithTouchIDPressedButton(_ sender: Any) {
        loginWithTouchIDOrFaceID()
    }
    
    func loginWithAlert() {
        let alert = UIAlertController(title: "Login", message: "Enter your credentials", preferredStyle: .alert)
        alert.addTextField { (usernameTextField) in
            usernameTextField.placeholder = "Username"
        }
        alert.addTextField { (passwordTextField) in
            passwordTextField.placeholder = "Password"
            passwordTextField.isSecureTextEntry = true
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (action) in
            // creadentials are valid, navigate to home screen
            var isEmptyTextField : Bool = false
            for textField in alert.textFields! {
                if textField.text == "" || textField.text == nil {
                    isEmptyTextField = true
                    continue
                }
            }
            if !isEmptyTextField {
                print("user authenticated")
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }else{
                print("Credentials are required")
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            // cancel the login process
            print("login cancelled")
        }
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkBiometryType() {
        var error : NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            if context.biometryType == .faceID {
                loginFTIDButton.setTitle("Face ID", for: .normal)
                isFaceIDSupported = true
            }else if context.biometryType == .touchID {
                loginFTIDButton.setTitle("Touch ID", for: .normal)
                isFaceIDSupported = false
            }else{
                loginFTIDButton.isHidden = false
            }
        }
    }
    
    func loginWithTouchIDOrFaceID() {
        var error : NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Login"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, err) in
                if success {
                    print("user authenticated")
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                }else{
                    if err != nil {
                        print(err!)
                    }
                    print("Login Failed")
                }
            }
        }
    }

}

