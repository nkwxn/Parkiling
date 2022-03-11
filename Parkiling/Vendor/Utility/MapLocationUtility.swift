//
//  MapLocationUtility.swift
//  Parkiling
//
//  Created by Nicholas on 06/03/22.
//

import Foundation
import CoreLocation
import MapKit
import Combine

class MapLocationUtility: NSObject, ObservableObject {
    // MapKit properties
    @Published var clLocation: CLLocation? = CLLocation() {
        didSet {
            region = MKCoordinateRegion(
                center: clLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
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
        locManager.startUpdatingLocation()
        return locManager
    }()
    
    let geocoder = CLGeocoder()
    
    // Recently parked vehicle
    @Published var parkingStatus: ParkingStatus?
    var cancellable = Set<AnyCancellable>()
    var parkingLocations = [ParkingStatus]()
    
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
        
//        if parkingStatus != nil {
//            setLocationCamera(at: parkingStatus)
//        }
    }
    
    func setLocationCoordinate(for clLocation: CLLocation?) {
        self.clLocation = clLocation
        listLocation()
        
//        if parkingStatus != nil {
//            setLocationCamera(at: parkingStatus)
//        }
    }
    
    func setLocationCamera(at status: ParkingStatus?) {
        if let status = status {
            let coordinate = status.coordinate.locationCoordinate()
            self.setLocationCoordinate(
                for: CLLocation(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )
            )
        } else {
            self.setLocationCoordinate(using: self.locManager)
        }
    }
    
    func listLocation() {
        geocoder.reverseGeocodeLocation(clLocation ?? CLLocation(latitude: 0.0, longitude: 0.0)) { placemarks, error in
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
}

extension MapLocationUtility: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied, .restricted, .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            setLocationCoordinate(using: manager)
        }
    }
    
    // when location is updating, should be
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        if let location = manager.location {
            setLocationCoordinate(for: location)
        }
    }
}
