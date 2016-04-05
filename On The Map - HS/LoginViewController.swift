//
//  LoginViewController.swift
//  On The Map - HS
//
//  Created by Hoff Henry Pereira da Silva on 24/12/15.
//  Copyright © 2015 hoff silva. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginAcitivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTexField: UITextField!
    
    
    
    var udacityAuthConvenience = UdacityAuthConvenience()
    override func viewDidLoad() {
        super.viewDidLoad()
        loginAcitivityIndicator.hidden = true
        userTextField.delegate = self
        passwordTexField.delegate = self
        
        userTextField.text = "hoff.henry@gmail.com"
        passwordTexField.text = "sardenta1"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
    
    @IBAction func authenticateActionButton(sender: AnyObject) {
        completeLogin()
    }

    @IBAction func signUpActionButton(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
        
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.isFirstResponder()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.isFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if userTextField.text! != "" && passwordTexField.text! != ""{
            completeLogin()
        }
        return true
    }
    
    
    func validateFields(){
        
        if userTextField.text!.rangeOfString(".") == nil && userTextField.text!.rangeOfString("@") == nil{
            let alert = UIAlertController(title: ":(", message: "Your E-mail is not valid!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }else if userTextField == "" {
            let alert = UIAlertController(title: ";)", message: "The E-mail field can not be empty!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }else if passwordTexField == ""{
            let alert = UIAlertController(title: ":)", message: "The Password field can not be empty!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
    }
    
    
    func completeLogin (){
        
        validateFields()
        loginAcitivityIndicator.hidden = false
        loginAcitivityIndicator.startAnimating()
        
        udacityAuthConvenience.authenticateUdacityAccount(userTextField.text!, password: passwordTexField.text!, onCompletion: { ( loginErrorMessage,  statusError,  success) -> Void in
            if success == true && loginErrorMessage == ""{
                self.loginAcitivityIndicator.hidden = true
                self.performSegueWithIdentifier("openMap", sender: self)
            }else{
                let alert = UIAlertController(title: ":(", message: "Error: \(statusError)\n\(loginErrorMessage)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.loginAcitivityIndicator.hidden = true
            }
            
        })
        
    }
    
}
