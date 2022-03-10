//
//  UserDefaults+Extensions.swift
//  Parkiling
//
//  Created by Nicholas on 08/03/22.
//

import Foundation

extension UserDefaults {
    @objc var parkingStatus: ParkingStatus? {
        get {
            guard let data = data(forKey: UDKey.parkingLocation.rawValue),
                  let saved = try? JSONDecoder().decode(ParkingStatus.self, from: data) else { return nil }
            return saved
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                setValue(encoded, forKey: UDKey.parkingLocation.rawValue)
            }
        }
    }
}
