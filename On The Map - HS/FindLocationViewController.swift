//
//  FindLocationViewController.swift
//  On The Map - HS
//
//  Created by Hoff Henry Pereira da Silva on 26/12/15.
//  Copyright © 2015 hoff silva. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBook


class FindLocationViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var button_Submit: UIButton!
    @IBOutlet weak var mapView_LocationFinded: MKMapView!
    @IBOutlet weak var textField_Link: UITextField!
    @IBOutlet weak var buttonFindOnTheMap: UIButton!
    @IBOutlet weak var textField_Location: UITextField!
    @IBOutlet weak var labelQuestion: UILabel!
    
    var udacityAuthConvenience = UdacityAuthConvenience()
    var parseConvenience = ParseConvenience()
    
    var isUpdate = false
    var cont = 0
    
    var latituteOfLocation = 0.0
    var longitudeOfLocation = 0.0
    
    var studentKey = ""
    var objId = ""
    
    let dropPin = MKPointAnnotation()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        textField_Location.delegate = self
        textField_Link.delegate = self
        textField_Link.hidden = true
        mapView_LocationFinded.hidden = true
        button_Submit.hidden = true
        mapView_LocationFinded.delegate = self
        activityIndicator.stopAnimating()
//        udacityAuthViewController.getPublicData { (firstName, lastName, key) -> () in
//            self.studentKey = key
//        }
        
       // studentLocationExists()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func button_findOnTheMap(sender: AnyObject) {
        verifyIfFieldsAreEmpty(textField_Location)
        setPin()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        verifyIfFieldsAreEmpty(textField)
        setPin()
        return true
    }
    
    
    func studentLocationExists(){
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        parseConvenience.gettingStudentLocations { (networkConectionError) -> () in
            if networkConectionError == true {
                let alert = UIAlertController(title: ":(", message: "Internet conection was lost or server is offline!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }else{
                self.udacityAuthConvenience.getPublicData(StudentsSingleton.univarsalKey, onCompletion:{ (firstName, lastName) -> () in
                    
                    self.parseConvenience.queryForAStudentLocation(StudentsSingleton.univarsalKey, onCompletion: { (objId) -> () in
                        
                        if objId == nil{
                            
                            self.setStudentLocation(StudentsSingleton.univarsalKey, firstName: firstName, lastName: lastName, mapString: self.textField_Location.text!, mediaURL: self.textField_Link.text!, latitude: self.latituteOfLocation, longitude: self.longitudeOfLocation)
                            self.activityIndicator.hidden = true
                        }else{
                            let alertController = UIAlertController(title: ":?", message: "Would you like update your location?", preferredStyle: .Alert)
                            
                            let noAction = UIAlertAction(title: "No", style: .Cancel) { (action) in
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                            alertController.addAction(noAction)
                            
                            let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
                                self.activityIndicator.hidden = false
                                self.activityIndicator.startAnimating()
                                self.updateStudentLocation(StudentsSingleton.univarsalKey, objId: objId!, firstName: firstName, lastName: lastName, mapString: self.textField_Location.text!, mediaURL: self.textField_Link.text!, latitude: self.latituteOfLocation, longitude: self.longitudeOfLocation)
                                self.activityIndicator.hidden = true
                            }
                            alertController.addAction(yesAction)
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.presentViewController(alertController, animated: true) {
                                    // ...
                                }
                            })
                            
                            
                        }
                        
                        
                        
                    })
                    
                })
                

            }
        }
        
        

    }
    
    func updateStudentLocation(key: String, objId : String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double){
        
            self.parseConvenience.updatingStudentLocation(StudentsModel(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), lastName: lastName, firstName: firstName, uniqueKey: key, mediaURL: mediaURL, objectId: objId, mapString: mapString))
            self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func setStudentLocation(key : String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double){
            self.parseConvenience.setStudentLocation(StudentsModel(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), lastName: lastName, firstName: firstName, uniqueKey: key, mediaURL: mediaURL, objectId: "", mapString: mapString))
            self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func verifyIfFieldsAreEmpty(textField : UITextField){
        if textField.text! != ""{
            textField.resignFirstResponder()
        }else{
            let alert = UIAlertController(title: ":(", message: "Your text field can not be empty!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func setPin(){
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        let geoCoder = CLGeocoder()
        let locationString = "\(textField_Location.text!)"
        geoCoder.geocodeAddressString(locationString, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            guard error == nil else{
                let alert = UIAlertController(title: ";)", message: "Your location could not be finded!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.activityIndicator.hidden = true
                return
            }
           // self.studentLocationExists()
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                //  print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                self.latituteOfLocation = coordinate!.latitude
                self.longitudeOfLocation = coordinate!.longitude
                
                self.dropPin.title = "Title"
                self.dropPin.subtitle = "subtitle"
                self.dropPin.coordinate = coordinate!
                var region = MKCoordinateRegion()
                region.center = coordinate!
                self.mapView_LocationFinded.addAnnotation(self.dropPin)
                self.textField_Location.hidden = true
                self.textField_Link.hidden = false
                self.mapView_LocationFinded.hidden = false
                self.buttonFindOnTheMap.hidden = true
                self.button_Submit.hidden = false
                self.mapView_LocationFinded.setRegion(region, animated: true)
                self.activityIndicator.hidden = true
            }
        })
    }

    
    @IBAction func action_SubmitButton(sender: AnyObject) {
        
        studentLocationExists()
    
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.image = UIImage(named:"pin")!
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

}
