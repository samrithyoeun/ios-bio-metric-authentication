 //
//  ViewController.swift
//  bio-metric-authentication
//
//  Created by Yoeun Samrith on 5/9/20.
//  Copyright © 2020 Yoeun Samrith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var authenticationButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var disableAuthenticationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch BioMetricManager.shared.bioMetricType {
        case .faceID:
            authenticationButton.setTitle("Enable Face ID", for: .normal)
            
        case .touchID:
            authenticationButton.setTitle("Enable Touch ID", for: .normal)
            
        default:
            authenticationButton.setTitle("No Bio Metric Feature" , for: .normal)
            authenticationButton.isEnabled = false
            
            loginButton.isHidden = true
        }
        
        disableAuthenticationButton.isEnabled = false
        loginButton.isEnabled = false
    }
    
    @IBAction func authenticationButtonDidTapped(_ sender: UIButton) {
        
       
        BioMetricManager.shared.shouldAuthenticate(callback: { (status, error) in
            
            self.loginButton.isEnabled = status
            
            if status {
                self.saveToken()
                self.authenticationButton.isEnabled = false
                self.disableAuthenticationButton.isEnabled = true
                
            }
            UIAlertController.show(error, in: self)
        })
    }
    
    @IBAction func loginButtonDidTapped(_ sender: UIButton) {
    guard UserDefaults.standard.bool(forKey: "enableBioMetric") else {
            UIAlertController.show("Please turn on Bio Metric Feature first", in: self)
            return
        }
        
        BioMetricManager.shared.shouldAuthenticate { (status, message) in
            if status {
                let username = UserDefaults.standard.string(forKey: "username") ?? ""
                let password = UserDefaults.standard.string(forKey: "password") ?? ""
                UIAlertController.show("you have logged in with  \nusername : \(username) \npassword : \(password)", in: self)
            }
        }
    }
    
    @IBAction func disableAuthenticationButtonDidTapped(_ sender: UIButton) {
        
        authenticationButton.isEnabled = true
        deleteToken()
        sender.isEnabled = false
    }
    
    private func saveToken() {
        UserDefaults.standard.set("admin", forKey: "username")
        UserDefaults.standard.set("1234", forKey: "password")
        UserDefaults.standard.set(true, forKey: "enableBioMetric")
    }
    
    private func deleteToken() {
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.set(false, forKey: "enableBioMetric")
    }

}

extension UIAlertController {

    static func show(_ message: String , in viewController: UIViewController) {
        let alert = UIAlertController()
        alert.message = message
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
