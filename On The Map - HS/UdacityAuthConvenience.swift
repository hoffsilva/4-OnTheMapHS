//
//  UdacityAuthViewController.swift
//  On The Map - HS
//
//  Created by Hoff Henry Pereira da Silva on 24/12/15.
//  Copyright © 2015 hoff silva. All rights reserved.
//

import UIKit

class UdacityAuthConvenience: NSObject {
    
    var loginErrorMessage = ""
    var statusError = Int()
    var success = false
    var firstName = ""
    var lastName = ""
    var key = ""

    func closeSessionUdacityAccount(onCompletion: () ->()){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in (sharedCookieStorage.cookies! as [NSHTTPCookie]) {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
           // print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                onCompletion()
            })
        }
        task.resume()
    }
    
    func authenticateUdacityAccount( user : String, password : String, onCompletion: (loginErrorMessage: String, statusError: Int, success : Bool) ->()){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(user)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            

            
            if let error = downloadError {
                print("Could not complete the request \(error.localizedDescription)")
                self.loginErrorMessage = error.localizedDescription
                
            }else{
                
                guard let data = data else {
                    print("No data was returned by the request!")
                    return
                }
                
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                
                //  print(newData)
                
                /* 6 - Parse the data (i.e. convert the data to JSON and look for values!) */
                let parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                } catch {
                    parsedResult = nil
                    print("Could not parse the data as JSON: '\(newData)'")
                    return
                }
                
             //   print(parsedResult)
                
                /* GUARD: Are the "photos" and "photo" keys in our result? */
                if let accountDictionary = parsedResult["account"] as? NSDictionary{
                    // print(accountDictionary)
                    if let registeredValue = accountDictionary["registered"] as? Int {
                        if registeredValue == 1{
                            self.success = true
                        }
                    }
                    if let keyOfUdacity = accountDictionary["key"] as? String{
                        StudentsSingleton.univarsalKey = keyOfUdacity
                    }
                }
                
                // print(parsedResult)
                
                
                
                if let loginStatus = parsedResult["status"] as? Int, let loginError = parsedResult["error"] as? String {
                    self.loginErrorMessage = loginError
                    self.statusError = loginStatus
                }
                
              
                
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                onCompletion(loginErrorMessage: self.loginErrorMessage, statusError: self.statusError, success : self.success)
            })
            
            
            }
            
        task.resume()

        
           
        
    }
    
    func getPublicData(uniqueKey: String, onCompletion: (firstName: String, lastName: String) ->()){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(uniqueKey)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
           
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(newData)'")
                return
            }
            
        //    print(parsedResult)
            
            guard let arrayUser = parsedResult["user"] as? NSDictionary else{
                 print("Cannot finded first name on \(parsedResult)")
                return
            }
            
            guard let firstName = arrayUser["first_name"] as? String else{
                print("Cannot finded first name on \(parsedResult)")
                return
            }
            
            guard let lastName = arrayUser["last_name"] as? String else{
                print("Cannot finded last_name on \(parsedResult)")
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                 onCompletion(firstName: firstName, lastName: lastName)
           })
           
            
            
            
        }
        task.resume()
    }

}
