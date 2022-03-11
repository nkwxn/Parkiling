//
//  ParkVehicleView.swift
//  Parkiling
//
//  Created by Nicholas on 05/03/22.
//

import SwiftUI
import MapKit

struct ParkVehicleView: View {
    //    @State coordinate
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = ParkVehicleViewModel()
    @Binding var status: ParkingStatus?
    
    init(status: Binding<ParkingStatus?>) {
        self._status = status
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Map(
                            coordinateRegion: $viewModel.region,
                            showsUserLocation: status == nil,
                            annotationItems: viewModel.parkingLocations
                        ) { parking in
                            MapMarker(
                                coordinate: parking.coordinate.locationCoordinate(),
                                tint: Color.accentColor
                            )
                        }
                            .frame(width: nil, height: 200)
                        HStack(spacing: 8) {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 24, weight: .regular, design: .rounded))
                            Text(status == nil ? viewModel.locName : status!.parkingLocation)
                                .lineLimit(3)
                        }
                    }
                    .padding(.bottom, 14)
                } header: {
                    Text("Location")
                }
                
                Section {
                    TextField("Lot Number", text: $viewModel.lotNumber)
                    TextField("Floor Level", text: $viewModel.level)
                    TextField("Additional Info", text: $viewModel.moreInfo)
                    HStack {
                        Text("Attachment")
                        Spacer()
                        if viewModel.chosenImage != nil {
                            Button {
                                viewModel.showImageDeletePrompt.toggle()
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                    Button {
                        // Action
                        viewModel.showImageSource.toggle()
                    } label: {
                        if let imageData = viewModel.chosenImage {
                            VStack {
                                Image(uiImage: imageData)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 240)
                                    .clipShape(Rectangle())
                                Text("Tap to Update Image")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .textCase(.uppercase)
                            }
                            .frame(height: 250)
                        } else {
                            HStack {
                                Spacer()
                                VStack {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .foregroundColor(Color.secondary)
                                        .scaledToFit()
                                        .frame(height: 100)
                                    Text("Tap to Choose Image Source")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .textCase(.uppercase)
                                }
                                Spacer()
                            }
                        }
                    }
                    .frame(height: 250)
                    .padding(.vertical, 8)
                } header: {
                    Text("Details")
                }
            }
            .onAppear {
                viewModel.setParking(status: status)
            }
            .listStyle(DefaultListStyle())
            .navigationTitle(status == nil ? "Park my Vehicle" : "Update Information")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(
                    placement: .navigationBarLeading
                ) {
                    Button("Cancel", role: .destructive) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(
                    placement: .navigationBarTrailing
                ) {
                    Button("Done", role: .none) {
                        presentationMode.wrappedValue.dismiss()
                        viewModel.saveParking()
                    }
                }
            }
            .alert("Delete Image?", isPresented: $viewModel.showImageDeletePrompt, actions: {
                Button("Cancel", role: .cancel) {
                    // no action required
                }
                Button("Delete", role: .destructive) {
                    viewModel.chosenImage = nil
                }
            }, message: {
                Text("Image deletion cannot be undone.")
            })
            .sheet(isPresented: $viewModel.showImagePicker) {
                // Dismissing function
            } content: {
                ImagePicker(image: $viewModel.chosenImage)
            }
            .fullScreenCover(isPresented: $viewModel.showCameraView) {
                // Dismissing function
            } content: {
                CameraView(image: $viewModel.chosenImage)
            }
            .confirmationDialog("Choose Image Resource", isPresented: $viewModel.showImageSource) {
                Button("Camera") {
                    viewModel.showCameraView.toggle()
                }
                Button("Photo Gallery") {
                    viewModel.showImagePicker.toggle()
                }
            }
        }
    }
}

struct ParkVehicleView_Previews: PreviewProvider {
    static var previews: some View {
        ParkVehicleView(status: .constant(nil))
    }
}
