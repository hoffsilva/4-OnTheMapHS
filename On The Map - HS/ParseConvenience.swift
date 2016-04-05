//
//  ParseConvenience.swift
//  On The Map - HS
//
//  Created by Hoff Henry Pereira da Silva on 27/12/15.
//  Copyright © 2015 hoff silva. All rights reserved.
//

import UIKit
import MapKit

class ParseConvenience: NSObject {
    
    func gettingStudentLocations(onCompletion: (networkConectionError : Bool) ->()){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error == nil { // Handle error...
                let parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                } catch {
                    parsedResult = nil
                    return
                }
                
                if let arrayOfResults = parsedResult["results"] as?[[String:AnyObject]]{
                            StudentsSingleton.arrayOfStudents.removeAll()
                            
                            for student in arrayOfResults{
                                StudentsSingleton.arrayOfStudents.append(StudentsModel(coordinate: CLLocationCoordinate2D(latitude: (student["latitude"] as? Double)!, longitude: (student["longitude"] as? Double)!), lastName: (student["lastName"] as? String)!, firstName: (student["firstName"] as? String)!, uniqueKey: (student["uniqueKey"] as? String)!, mediaURL: (student["mediaURL"] as? String)!, objectId: (student["objectId"] as? String)!, mapString: (student["mapString"] as? String)!))
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                onCompletion(networkConectionError: false)
                            })
                        }else{
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                onCompletion(networkConectionError: true)
                            })
                        }
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onCompletion(networkConectionError: true)
                })
            }
            
                
           
            
                       
        }
        task.resume()
    }

    
    func setStudentLocation(student : StudentsModel){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(student.mapString)\", \"mediaURL\": \"\(student.mediaURL)\",\"latitude\": \(student.coordinate.latitude), \"longitude\": \(student.coordinate.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
        }
        task.resume()
    }
    
    func updatingStudentLocation(student : StudentsModel){
        
        let urlString = "https://api.parse.com/1/classes/StudentLocation/\(student.objectId)"
       // print(urlString)
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(student.mapString)\", \"mediaURL\": \"\(student.mediaURL)\",\"latitude\": \(student.coordinate.latitude), \"longitude\": \(student.coordinate.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
           // print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        
    }
    
    func queryForAStudentLocation(uniqueKey : String, onCompletion: (objId : String?) ->()){
        
    
        
        let urlString = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22" +  (uniqueKey) + "%22%7D"
        
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { /* Handle error */ return }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            //print(parsedResult)
            
            guard let arrayOfResults = parsedResult["results"] as?[[String:AnyObject]] else{
                print("Nao encontrei results no parsedResult.")
                return
            }
            
            if arrayOfResults.count > 0{
                if let objDict = arrayOfResults[0] as? [String: AnyObject]{
                    if let objId = objDict["objectId"] as? String{
                      //  print(objId)
                        onCompletion(objId: objId)
                    }
                    else{
                        onCompletion(objId: nil)
                    }
                }else{
                    onCompletion(objId: nil)
                }
            }else{
                onCompletion(objId: nil)
            }
            
        }
        
        task.resume()
    }
    
    func deleteId(objId : String){

        let urlString = "https://api.parse.com/1/classes/StudentLocation/\(objId)"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "DELETE"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        
        
        
    }

}
