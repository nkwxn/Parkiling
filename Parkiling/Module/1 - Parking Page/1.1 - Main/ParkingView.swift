//
//  ParkingView.swift
//  Parkiling
//
//  Created by Nicholas on 04/03/22.
//

import SwiftUI
import MapKit

struct ParkingView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.334_900,
                                       longitude: -122.009_020),
        latitudinalMeters: 750,
        longitudinalMeters: 750
    )
    @State private var frameSize: CGSize = .zero
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $region)
                    .ignoresSafeArea(.container, edges: .bottom)
                ViewSizeReader(size: $frameSize) {
                    VStack {
                        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                        Text("ABCD")
                        Button("Park My Vehicle") {
                            // Open modal
                        }
                        .buttonStyle(ParkilingButtonStyle(.primary))
                    }
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.vertical, 30)
                }
            }
            .navigationTitle("Parking")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: frameSize) { newValue in
                // Should throw height to the CLLocation
                print("Height: \(frameSize.height)")
            }
        }
    }
}

struct ParkingView_Previews: PreviewProvider {
    static var previews: some View {
        ParkingView()
    }
}
