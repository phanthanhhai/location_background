//
//  ViewController.swift
//  LocationBackground
//
//  Created by haipt on 9/4/15.
//  Copyright (c) 2015 Framgia. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var latitudeLb: UILabel!
    @IBOutlet weak var longtitudeLb: UILabel!
    @IBOutlet weak var getLocationBtn: UIButton!
    
    
    @IBOutlet weak var pushLocalBtn: UIButton!
    
    private var locationManager: CLLocationManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
        
//        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways){
                var currentLocation = locationManager?.location
                longtitudeLb.text = "\(currentLocation!.coordinate.longitude)"
                latitudeLb.text = "\(currentLocation!.coordinate.latitude)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as? CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if placemark != nil {
            //stop updating location to save battery life
//            locationManager?.stopUpdatingLocation()
            println(placemark!.locality)
            println(placemark!.postalCode)
            println(placemark!.administrativeArea)
            println(placemark!.country)
            self.pushLocalTouched()
        }
    }

    @IBAction func pushLocalTouched() {
        var notification = UILocalNotification()
        notification.alertBody = "New location" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = NSDate(timeIntervalSinceNow: 3)
        
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.applicationIconBadgeNumber = 1;
        
        
        
        notification.userInfo = ["UUID": "aaaaaaaa", ] // assign a unique identifier to the notification so that we can retrieve it later
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}

