//
//  ParkingView.swift
//  Parkiling
//
//  Created by Nicholas on 04/03/22.
//

import SwiftUI
import MapKit

struct ParkingView: View {
    @StateObject var viewModel = ParkingViewModel()
    
    var body: some View {
        NavigationView {
            ParkingViewContainer(isVStack: $viewModel.showParkingDetails) {
                ViewSizeReader(size: $viewModel.mapSize) {
                    Map(
                        coordinateRegion: $viewModel.region,
                        showsUserLocation: viewModel.parkingStatus == nil,
                        annotationItems: viewModel.parkingLocations
                    ) { parking in
                        MapMarker(
                            coordinate: parking.coordinate.locationCoordinate(),
                            tint: Color.accentColor
                        )
                    }
                    .ignoresSafeArea(
                        .container,
                        edges: .bottom
                    )
                }
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.parkingStatus == nil ? "Current Location" : "Parked Since \(viewModel.parkingStatus!.getFormattedDate(for: .startDate)) on")
                            .font(.system(.caption, design: .rounded))
                            .textCase(.uppercase)
                            .foregroundColor(.secondary)
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 24, weight: .regular, design: .rounded))
                            Text(viewModel.parkingStatus == nil ? viewModel.locName : viewModel.parkingStatus!.parkingLocation)
                                .lineLimit(3)
                        }
                        .background(Color.primarySystemBackground)
                    }
                    
                    // Container for the parking area details
                    if viewModel.showParkingDetails {
                        VStack(alignment: .leading, spacing: 8) {
                            if let lotNumber = viewModel.parkingStatus?.lotNumber,
                               let level = viewModel.parkingStatus?.floorNumber,
                               !lotNumber.isEmpty || !level.isEmpty {
                                HStack {
                                    if !lotNumber.isEmpty {
                                        Divider()
                                        TextStackView(title: "Lot", desc: lotNumber)
                                    }
                                    Divider()
                                    if !level.isEmpty {
                                        TextStackView(title: "Level", desc: level)
                                        Divider()
                                    }
                                }
                                .frame(height: 50)
                            }
                            
                            // Show the Additional Information
                            if let info = viewModel.parkingStatus?.additionals,
                               !info.isEmpty {
                                VStack(alignment: .leading) {
                                    Text("Additional Info")
                                        .font(.system(.caption, design: .rounded))
                                        .textCase(.uppercase)
                                        .foregroundColor(.secondary)
                                    Text(info)
                                }
                            }
                            
                            if let image = viewModel.parkingStatus?.imageData {
                                VStack(alignment: .leading) {
                                    Text("Image")
                                        .font(.system(.caption, design: .rounded))
                                        .textCase(.uppercase)
                                        .foregroundColor(.secondary)
                                    Image(uiImage: UIImage(data: image)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 240)
                                        .clipShape(Rectangle())
                                }
                            }
                        }
                        .transition(.opacity)
                    }
                    
                    // Should change to 2 buttons when on parking state
                    if viewModel.parkingStatus == nil {
                        Button("Park My Vehicle") {
                            // Open modal
                            viewModel.showNewParking.toggle()
                        }
                        .buttonStyle(ParkilingButtonStyle(.primary))
                    } else {
                        HStack {
                            Button("\(viewModel.showParkingDetails ? "Hide" : "Show") Details") {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    viewModel.showParkingDetails.toggle()
                                }
                            }
                            .buttonStyle(ParkilingButtonStyle(.secondary))
                            .frame(width: 150)
                            Button("I'm Leaving Soon") {
                                // Show prompt
                                viewModel.showLeavingPrompt.toggle()
                            }
                            .buttonStyle(ParkilingButtonStyle(.primary))
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(20)
                .padding(.horizontal, viewModel.showParkingDetails ? 0 : 16)
                .padding(.vertical, viewModel.showParkingDetails ? 0 : 30)
                .transition(.scale)
            }
            .transition(.scale)
            .navigationTitle("Parking")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.parkingStatus != nil && viewModel.showParkingDetails {
                        Button("Edit") {
                            // Show edit modal (same view but different)
                            viewModel.showNewParking.toggle()
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.showNewParking) {
                // Dismissal Function
            } content: {
                ParkVehicleView(status: $viewModel.parkingStatus)
            }
            .alert("Are you leaving soon?", isPresented: $viewModel.showLeavingPrompt) {
                Button("No", role: .cancel) {}
                Button("Yes") {
                    viewModel.leaveParkingLot()
                }
            } message: {
                Text("Please make sure that you are about to leave the place.")
            }
            
        }
        .onChange(of: viewModel.showParkingDetails) { newValue in
            // should change the map value
            viewModel.setLocationCamera()
        }
    }
}

struct ParkingView_Previews: PreviewProvider {
    static var previews: some View {
        ParkingView()
    }
}

struct ParkingViewContainer<Content: View>: View {
    @Binding var isVStack: Bool
    var content: () -> Content
    
    init(isVStack: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self._isVStack = isVStack
        self.content = content
    }
    
    var body: some View {
        if isVStack {
            VStack(spacing: 0, content: content)
        } else {
            ZStack(alignment: .bottom, content: content)
        }
    }
}
