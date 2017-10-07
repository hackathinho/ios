//
//  ViewController.swift
//  SmartJump
//
//  Created by Boris Chirino on 07/10/2017.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import SpeedLog


class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager : CLLocationManager!
    var  mapView :GMSMapView!
    var currentLocation :CLLocation?
    lazy var geocoder :GMSGeocoder = {
        let gc = GMSGeocoder()
        return gc
    }()
    var geocoderBusy :Bool = false
    
    
    
    
    //MARK: ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        
        let camera = GMSCameraPosition.camera(withLatitude: 43.36357, longitude: -8.42563, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.isMyLocationEnabled = true
        view = mapView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        let autorizationStatus = CLLocationManager.authorizationStatus()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5
        locationManager.delegate = self
        
        
        switch autorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .denied:
            print("Autorization denied")
        default:()
            
        }
    }
    
    

    
    
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            SpeedLog.print("Autorized")
            locationManager.requestLocation()
        }
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !geocoderBusy else {
            return
        }
        
        if let lastLocation = locations.last {
            SpeedLog.print(lastLocation)
            currentLocation = lastLocation
            
            
            geocoderBusy = true
            geocoder.reverseGeocodeCoordinate(lastLocation.coordinate, completionHandler: { (response, error) in
                self.geocoderBusy = false
                if let firstResult = response?.firstResult() {
                    self.updateMap(address: firstResult)
                }else {
                    SpeedLog.print("reverse geocoder fail")
                    self.locationManager.requestLocation()
                }
            })
        }
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        SpeedLog.print("Location initialization failed \(error.localizedDescription)")
    }
    
    
    
    
    
    
    //MARK: instance methods
    func updateMap(address :GMSAddress) {
        DispatchQueue.main.async {
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = address.coordinate
            marker.title = address.lines.flatMap{ $0 }?.first
            marker.snippet = address.postalCode
            marker.map = self.mapView

            let camera = GMSCameraPosition.camera(withTarget: address.coordinate, zoom: 13.0)
            self.mapView.animate(to: camera)
        }
    }
    
    
}






