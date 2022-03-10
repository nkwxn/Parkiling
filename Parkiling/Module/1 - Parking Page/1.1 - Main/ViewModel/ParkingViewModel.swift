//
//  ParkingViewModel.swift
//  Parkiling
//
//  Created by Nicholas on 05/03/22.
//

import Foundation
import UIKit
import Combine
import CoreLocation
import MapKit

class ParkingViewModel: MapLocationUtility {
    // SwiftUI View frames
    @Published var squareSize: CGSize = .zero
    @Published var mapSize: CGSize = .zero
    
    // Show modal
    @Published var showNewParking = false
    @Published var showUpdateParking = false
    @Published var showParkingDetails = false
    @Published var showLeavingPrompt = false
    
    // Recently parked vehicle
    @Published var parkingStatus: ParkingStatus?
    var cancellable = Set<AnyCancellable>()
    
    var parkingLocations = [ParkingStatus]()
    
    override init() {
        super.init()
        
        // Setup geocoder / pin location to the recently parked vehicle (parking status)
        UDHelper.shared.subsParking { [weak self] status in
            self?.parkingStatus = status
            if self?.parkingStatus == nil {
                self?.parkingLocations.removeAll()
                self?.showNewParking = false
                self?.showUpdateParking = false
                self?.showParkingDetails = false
                self?.showLeavingPrompt = false
            } else {
                let coordinate = status?.coordinate.locationCoordinate()
                self?.parkingLocations.append(status!)
                self?.region = MKCoordinateRegion(
                    center: coordinate!,
                    latitudinalMeters: 750,
                    longitudinalMeters: 750
                )
            }
            
            self?.setLocationCamera()
        }.store(in: &cancellable)
        
        self.setLocationCamera()
    }
    
    func leaveParkingLot() {
        UDHelper.shared.setParking(with: nil)
    }
    
    override func setLocationCoordinate(using locationMgr: CLLocationManager) {
        super.setLocationCoordinate(using: locationMgr)
        if parkingStatus != nil {
            setLocationCamera()
        }
    }
    
    func setLocationCamera() {
        if let status = parkingStatus {
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
}
