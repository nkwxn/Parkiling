//
//  MapLocationUtility.swift
//  Parkiling
//
//  Created by Nicholas on 06/03/22.
//

import Foundation
import CoreLocation
import MapKit

class MapLocationUtility: NSObject, ObservableObject, CLLocationManagerDelegate {
    // MapKit properties
    @Published var clLocation: CLLocation? = CLLocation() {
        didSet {
            region = MKCoordinateRegion(
                center: clLocation!.coordinate,
                latitudinalMeters: 700,
                longitudinalMeters: 700
            )
        }
    }
    @Published var region = MKCoordinateRegion()
    
    // Location Name Property
    @Published var locName = ""
    
    let locManager: CLLocationManager = {
        let locManager = CLLocationManager()
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        return locManager
    }()
    
    let geocoder = CLGeocoder()
    
    override init() {
        locManager.requestWhenInUseAuthorization()
        super.init()
        locManager.delegate = self
    }
    
    deinit {
        print("ViewModel is deinitialized")
    }
    
    func setLocationCoordinate(using locationMgr: CLLocationManager) {
        switch locationMgr.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            clLocation = locationMgr.location
        default:
            self.clLocation = CLLocation(
                latitude: CLLocationDegrees(37.334_900),
                longitude: CLLocationDegrees(-122.009_020)
            )
        }
        listLocation()
    }
    
    func setLocationCoordinate(for clLocation: CLLocation?) {
        self.clLocation = clLocation
        listLocation()
    }
    
    func listLocation() {
        geocoder.reverseGeocodeLocation(clLocation!) { placemarks, error in
            guard let placemarks = placemarks else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            let placemark = placemarks[0]
            self.locName = placemark.name!
        }
    }
    
    // Masih gatau mau dipake gimana :")
    // Latitude (y): 90, longitude (x): 180
    func moveLocationCamera(offsetX: Double = 0.0, offsetY: Double = 0.0) {
        print(offsetY)
        print("Original coordinate: \(clLocation!.coordinate)")
        let latitudeOffset = clLocation!.coordinate.latitude + offsetY
        let longitudeOffset = clLocation!.coordinate.longitude + offsetX
        let newCoordinate = CLLocation(
            latitude: latitudeOffset,
            longitude: longitudeOffset
        )
        print("Offsetted Coordinate: \(newCoordinate.coordinate)")
        clLocation = newCoordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied, .restricted, .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            setLocationCoordinate(using: manager)
        }
    }
}
