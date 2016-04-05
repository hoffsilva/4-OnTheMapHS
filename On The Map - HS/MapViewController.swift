//
//  MapViewController.swift
//  On The Map - HS
//
//  Created by Hoff Henry Pereira da Silva on 25/12/15.
//  Copyright © 2015 hoff silva. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{
    
    var udacityAuthConvenience = UdacityAuthConvenience()
    var parseConvenience = ParseConvenience()
   
    var overlayView = UIView()
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var mapa: MKMapView!
    
    @IBAction func logout(sender: AnyObject) {
        loadActivityIndicator()
        logoutOfUdacity()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapa.delegate = self
        
    }
    
    @IBAction func refreshStudents(sender: AnyObject) {
        settingStudentsOnMap()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        settingStudentsOnMap()
    }
    
    func settingStudentsOnMap(){
        self.mapa.removeAnnotations(self.mapa.annotations)
        var annotations = [MKPointAnnotation]()
        parseConvenience.gettingStudentLocations { (networkConectionError) -> () in
            self.loadActivityIndicator()
            if networkConectionError == true{
                let alert = UIAlertController(title: ":(", message: "Internet conection was lost or server is offline!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.overlayView.removeFromSuperview()
                return

            }else{
                for student in StudentsSingleton.arrayOfStudents {
                   // print("\(student.firstName) \(student.mapString)")
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = student.coordinate
                    annotation.title = "\(student.firstName) \(student.lastName)"
                    annotation.subtitle = student.mediaURL
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                
                // When the array is complete, we add the annotations to the map.
                self.mapa.addAnnotations(annotations)
                self.mapa.setCenterCoordinate(self.mapa.region.center, animated: true)
                self.overlayView.removeFromSuperview()
            }
        }
        
    }
    
   
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    }
        else {
            pinView!.annotation = annotation
        }
        pinView!.canShowCallout = true
        pinView!.image = UIImage(named:"pin")!
        pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)

        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    func logoutOfUdacity(){
        udacityAuthConvenience.closeSessionUdacityAccount { () -> () in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func loadActivityIndicator(){
        self.overlayView = UIView(frame: self.view.bounds)
        self.overlayView.backgroundColor = UIColor(red: 250, green: 250, blue: 250, alpha: 0.5)
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.activityIndicator.alpha = 1.0;
        self.activityIndicator.center = self.view.center;
        self.activityIndicator.hidesWhenStopped = false;
        self.overlayView.addSubview(activityIndicator)
        self.view.addSubview(overlayView)
        self.view.bringSubviewToFront(overlayView)
        self.activityIndicator.startAnimating()
    }

    
}
