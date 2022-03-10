//
//  ParkilingApp.swift
//  Parkiling
//
//  Created by Nicholas on 04/03/22.
//

import SwiftUI

@main
struct ParkilingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            ParkingView()
                .font(.system(.body, design: .rounded))
        }
    }
}
