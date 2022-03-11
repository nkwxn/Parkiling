//
//  ParkVehicleViewModel.swift
//  Parkiling
//
//  Created by Nicholas on 05/03/22.
//

import Foundation
import CoreLocation
import MapKit
import Combine

class ParkVehicleViewModel: MapLocationUtility {
    // For text fields
    @Published var lotNumber: String = ""
    @Published var level: String = ""
    @Published var moreInfo: String = ""
    @Published var chosenImage: UIImage? = nil
    
    // To show the image picker
    @Published var showImageSource = false
    @Published var showImagePicker = false
    @Published var showCameraView = false
    @Published var showImageDeletePrompt = false
    
    override var parkingStatus: ParkingStatus? {
        didSet {
            if let parkingStatus = parkingStatus {
                self.lotNumber = parkingStatus.lotNumber
                self.level = parkingStatus.floorNumber
                self.moreInfo = parkingStatus.additionals
                self.chosenImage = parkingStatus.imageData == nil ? nil : UIImage(data: parkingStatus.imageData!)
                self.region = MKCoordinateRegion(center: parkingStatus.coordinate.locationCoordinate(), latitudinalMeters: 750, longitudinalMeters: 750)
            }
        }
    }
    
    override init() {
        super.init()
        self.parkingStatus = nil
        
        UDHelper.shared.subsParking { [weak self] parkingStatus in
            if let parkingStatus = parkingStatus {
                self?.parkingStatus = parkingStatus
                self?.parkingLocations.append(parkingStatus)
                self?.setLocationCoordinate(using: self!.locManager)
                let coordinate = parkingStatus.coordinate.locationCoordinate()
                self?.setLocationCoordinate(
                    for: CLLocation(
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude
                    )
                )
            }
        }.store(in: &cancellable)
    }
    
    // To set the parking ID when it is not nil
    func setParking(status: ParkingStatus?) {
        self.parkingStatus = status
    }
    
    // Function to save and update the parking status
    func saveParking() {
        if let status = parkingStatus {
            // Update
            status.lotNumber = lotNumber
            status.floorNumber = level
            status.additionals = moreInfo
            status.imageData = chosenImage?.jpegData(compressionQuality: 1.0)
//            UDHelper.shared.setParking(with: nil)
            UDHelper.shared.setParking(
                with: status
            )
        } else {
            // create new
            UDHelper.shared.setParking(
                with: ParkingStatus(
                    coordinate: Coordinate(latitude: region.center.latitude, longitude: region.center.longitude),
                    parkingLocation: locName,
                    lotNumber: lotNumber,
                    floorNumber: level,
                    additionals: moreInfo,
                    imageData: chosenImage?.jpegData(compressionQuality: 1.0)
                )
            )
        }
    }
}
