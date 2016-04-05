//
//  StudentsModel.swift
//  On The Map - HS
//
//  Created by Hoff Henry Pereira da Silva on 28/12/15.
//  Copyright © 2015 hoff silva. All rights reserved.
//

import UIKit
import MapKit


class StudentsModel: NSObject  {
    
    init(coordinate : CLLocationCoordinate2D,lastName : String, firstName : String, uniqueKey : String, mediaURL : String, objectId : String, mapString : String) {
        
        self.coordinate = coordinate
        self.lastName = lastName
        self.firstName = firstName
        self.uniqueKey = uniqueKey
        self.mediaURL = mediaURL
        self.objectId = objectId
        self.mapString = mapString
        
    }
    
    var coordinate : CLLocationCoordinate2D
    var lastName : String
    var firstName : String
    var uniqueKey : String
    var mediaURL : String
    var objectId : String
    var mapString : String
    
    
    var arrayOfStudents = [StudentsModel]()
   

}
