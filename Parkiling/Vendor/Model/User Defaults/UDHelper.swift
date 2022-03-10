//
//  UDHelper.swift
//  Parkiling
//
//  Created by Nicholas on 08/03/22.
//

import Foundation
import Combine

enum UDKey: String {
    case parkingLocation
}

class UDHelper {
    static let shared = UDHelper()
    
    let defaults = UserDefaults(suiteName: "group.com.nkwxn.Parkiling") ?? UserDefaults.standard
    
    func setParking(with data: ParkingStatus?) {
        defaults.parkingStatus = data
    }
    
    func subsParking(receiveCompletion: @escaping ((ParkingStatus?) -> Void)) -> AnyCancellable {
        defaults.publisher(for: \.parkingStatus)
            .eraseToAnyPublisher()
            .sink(receiveValue: receiveCompletion)
    }
}
