//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Brian Voong on 3/24/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    let titleLabel: UILabel = {
        let tl = UILabel()
        tl.text = "Rolodex"
        tl.font = UIFont.systemFont(ofSize: 50)
        tl.textAlignment = .center
        
        return tl
    }()
    
    let messageLabel: UILabel = {
        let tl = UILabel()
        tl.text = "Welcome back."
        tl.font = UIFont.systemFont(ofSize: 20)
        tl.textColor = .gray
        tl.textAlignment = .center
        
        return tl
    }()
    
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
//
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, err) in
            
            if let err = err {
                print("Failed to sign in with email:", err)

                // Handle Errors here.
                
                if let errCode = AuthErrorCode(rawValue: err._code) {
                    
                    //https://firebase.google.com/docs/reference/swift/firebaseauth/api/reference/Enums/AuthErrorCode
                    switch errCode {
                        case .userNotFound:
                            let errorAlert = UIAlertController(title: "Error", message: "Your username does not match our records. Please try logging in with your email, or contact dj.satoda@gmail.com for support", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                            self.present(errorAlert, animated: true, completion: nil)
                            return
                        case .networkError:
                            let errorAlert = UIAlertController(title: "Error", message: "Experiencing connectivity issues. Please try logging in again.", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                            self.present(errorAlert, animated: true, completion: nil)
                            return
                        case .wrongPassword:
                            let errorAlert = UIAlertController(title: "Error", message: "Incorrect password. Your password does not match our records. Please try again or contact dj.satoda@gmail.com for support", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                            self.present(errorAlert, animated: true, completion: nil)
                        default:
                            print("Create User Error: \(err)")
                    }
                }
                
                let errorAlert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            
            print("Successfully logged back in with user:", user?.user.uid ?? "")
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)
            ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 25, paddingRight: 0, width: 0, height: 50)
        
        setupInputFields()
        
        // Dismisses keyboard if you tap screen
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
//        stackView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
//
        stackView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
        
        
//        view.addSubview(messageLabel)
//        messageLabel.backgroundColor = .orange
//        messageLabel.anchor(top: titleLabel.bottomAnchor, left: stackView.leftAnchor, bottom: nil, right: stackView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
    }
}









