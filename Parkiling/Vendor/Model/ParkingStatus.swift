//
//  ParkingStatus.swift
//  Parkiling
//
//  Created by Nicholas on 06/03/22.
//

import Foundation
import MapKit

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
    
    func locationCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}

class ParkingStatus: NSObject, Codable, Identifiable {
    var id = UUID()
    var coordinate: Coordinate
    var parkingLocation: String
    var lotNumber: String
    var floorNumber: String
    var additionals: String
    var startDate: Date
    var endDate: Date?
    var imageData: Data?
    
    init(
        coordinate: Coordinate,
        parkingLocation: String,
        lotNumber: String,
        floorNumber: String,
        additionals: String,
        imageData: Data?,
        isEnd: Bool = false
    ) {
        self.coordinate = coordinate
        self.parkingLocation = parkingLocation
        self.lotNumber = lotNumber
        self.floorNumber = floorNumber
        self.additionals = additionals
        self.imageData = imageData
        self.startDate = Date()
        self.endDate = isEnd ? Date() : nil
    }
    
    func endParking() {
        endDate = Date()
    }
    
    func getFormattedDate(for property: DateProperty) -> String {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .none
        switch property {
        case .startDate:
            return df.string(from: startDate)
        case .endDate:
            return df.string(from: endDate!)
        }
    }
    
    enum DateProperty {
        case startDate
        case endDate
    }
}
