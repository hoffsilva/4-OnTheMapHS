//
//  TableViewController.swift
//  On The Map - HS
//
//  Created by Hoff Henry Pereira da Silva on 25/12/15.
//  Copyright © 2015 hoff silva. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController{
    
    var udacityAuthConvenience = UdacityAuthConvenience()
    
    var parseConvenience = ParseConvenience()
    
    var overlayView = UIView()
    
    var activityIndicator = UIActivityIndicatorView()
    

    @IBOutlet weak var activityIndicatorTableView: UIActivityIndicatorView!
    
    @IBAction func actionLogoutButton(sender: AnyObject) {
        loadActivityIndicator()
        logoutOfUdacity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionRefreshButton(sender: AnyObject) {
        
        listingStudents()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        activityIndicatorTableView.tintColor = UIColor.greenColor()
        activityIndicatorTableView.hidden = false
        activityIndicatorTableView.startAnimating()
          listingStudents()
    }


    func listingStudents(){
        parseConvenience.gettingStudentLocations { (networkConectionError) -> () in
            self.loadActivityIndicator()
            if networkConectionError == true{
                let alert = UIAlertController(title: ":(", message: "Internet conection was lost or server is offline!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.overlayView.removeFromSuperview()
                return
            }else{
                self.tableView.reloadData()
                self.activityIndicatorTableView.hidden = true
                self.overlayView.removeFromSuperview()

            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsSingleton.arrayOfStudents.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell", forIndexPath: indexPath) as! TableViewCell
        
        cell.labelNameStudent.text = "\(StudentsSingleton.arrayOfStudents[indexPath.row].firstName) \(StudentsSingleton.arrayOfStudents[indexPath.row].lastName)"
        cell.labelMediaURL.text = "\(StudentsSingleton.arrayOfStudents[indexPath.row].mediaURL)"
    
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        //if let toOpen = studentsModel[indexPath.row].mediaURL {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            app.openURL(NSURL(string: "\(StudentsSingleton.arrayOfStudents[indexPath.row].mediaURL)")!)
       // }

    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deletar = UITableViewRowAction(style: .Normal, title: "Excluir") { action, index in
            self.parseConvenience.deleteId(StudentsSingleton.arrayOfStudents[indexPath.row].objectId)
            self.listingStudents()
        }
        deletar.backgroundColor = UIColor.redColor()
        
        return [deletar]
    }
    
    func logoutOfUdacity(){
        udacityAuthConvenience.closeSessionUdacityAccount { () -> () in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func loadActivityIndicator(){
        self.overlayView = UIView(frame: self.tableView.bounds)
        self.overlayView.backgroundColor = UIColor(red: 250, green: 250, blue: 250, alpha: 0.5)
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.activityIndicator.alpha = 1.0;
        self.activityIndicator.center = self.view.center;
        self.activityIndicator.hidesWhenStopped = true;
        self.overlayView.addSubview(activityIndicator)
        self.tableView.addSubview(overlayView)
        self.tableView.bringSubviewToFront(overlayView)
        self.activityIndicator.startAnimating()
    }
    
    
}
