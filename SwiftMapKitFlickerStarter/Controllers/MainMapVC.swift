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

class MainMapVC: UIViewController, UIGestureRecognizerDelegate {
    
    private let locationManager = CLLocationManager()
    private let authorizationStatus = CLLocationManager.authorizationStatus()
    private let regionRadius: Double = 1000
    
    private var screenSize = UIScreen.main.bounds
    
    private let spinner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView()
        spin.style = .whiteLarge
        spin.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return spin
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private var collectionView: UICollectionView?
    var flowLayout = UICollectionViewFlowLayout()
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pullHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pullUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        configureLocationServices()
        addDoubleTap()
        configureCollectionView()
        
    }
    
    @IBAction func centerMapButtonPressed(_ sender: Any) {
        if(authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse){
            centerMapOnUserLocation()
        }
    }
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        pullUpView.addSubview(collectionView!)
    }
    
    private func addSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
        swipe.direction = .down
        pullUpView.addGestureRecognizer(swipe)
    }
    
    
    private func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
    }
    
    
    private func animateViewUp() {
        pullHeightConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func animateViewDown() {
        pullHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    private func showSpinner(){
        spinner.center = CGPoint(x: (screenSize.width/2) - ((spinner.frame.width)/2), y: 150)
        spinner.startAnimating()
        collectionView?.addSubview(spinner)
    }
    
    private func removeSpinner(){
        spinner.removeFromSuperview()
        print("remove spinner")
    }
    
    private func showProgressLabel(){
        progressLabel.frame = CGRect(x: (screenSize.width/2) - 100, y: 175, width: 200, height: 50)
        progressLabel.text = "Progressing...."
        collectionView?.addSubview(progressLabel)
    }
    
    private func removeProgressLabel(){
        progressLabel.removeFromSuperview()
    }
    
    
}

extension MainMapVC: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            return nil
        }
        
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        pinAnnotation.animatesDrop = true
        return pinAnnotation
        
    }
    
    func centerMapOnUserLocation(){
        guard let coordinate = locationManager.location?.coordinate else{return}
        
        let coordinateRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func dropPin(sender: UITapGestureRecognizer){
        print("dddd")
        removePin()
        removeSpinner()
        removeProgressLabel()
        
        animateViewUp()
        addSwipe()
        showSpinner()
        showProgressLabel()
        
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        print("ddd",touchCoordinate.latitude)
        
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation)
        
        let coordinateRegion = MKCoordinateRegion(center: touchCoordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        print(flickrUrl(forApiKey: apiKey, withAnnotation: annotation, andNumberOfPhotos: 10))
        
        PhotoService.instance.retriveUrls(forAnnotation: annotation) { (finished) in
            if(finished){
                print("yesss", PhotoService.instance.getImageUrls())
            }
        }
    }
    
    func removePin() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
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

extension MainMapVC: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else{return UICollectionViewCell()}
        return cell
    }
    
    
}
