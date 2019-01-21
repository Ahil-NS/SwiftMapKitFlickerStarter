//
//  ViewController.swift
//  SwiftMapKitFlickerStarter
//
//  Created by MacBook on 1/21/19.
//  Copyright © 2019 Ahil. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

import Alamofire
import AlamofireImage

class MainMapVC: UIViewController {

    
    let locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        configureLocationServices()    }

    @IBAction func centerMapButtonPressed(_ sender: Any) {
        if(authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse){
            centerMapOnUserLocation()
        }
    }
    
}

extension MainMapVC: MKMapViewDelegate{
    
    func centerMapOnUserLocation(){
        guard let coordinate = locationManager.location?.coordinate else{return}
       
        let coordinateRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MainMapVC: CLLocationManagerDelegate{
    
    func configureLocationServices(){
        if(authorizationStatus == .notDetermined){
            locationManager.requestAlwaysAuthorization()
        }else{
            return 
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
    
}

