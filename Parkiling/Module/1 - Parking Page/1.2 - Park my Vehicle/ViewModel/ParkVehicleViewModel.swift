//
//  ParkVehicleViewModel.swift
//  Parkiling
//
//  Created by Nicholas on 05/03/22.
//

import Foundation
import CoreLocation
import MapKit

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
    
    var parkingStatus: ParkingStatus? {
        didSet {
            if let parkingStatus = parkingStatus {
                self.lotNumber = parkingStatus.lotNumber
                self.level = parkingStatus.floorNumber
                self.moreInfo = parkingStatus.additionals
                self.chosenImage = parkingStatus.imageData == nil ? nil : UIImage(data: parkingStatus.imageData!)
            }
        }
    }
    
    override init() {
        super.init()
        self.parkingStatus = nil
    }
    
    // Init view for updating status
    init(status: ParkingStatus?) {
        super.init()
        self.parkingStatus = status
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
