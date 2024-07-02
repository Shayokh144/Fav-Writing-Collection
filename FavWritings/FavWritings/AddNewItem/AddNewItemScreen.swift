//
//  AddNewItemScreen.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 1/7/24.
//

import SwiftUI
import PhotosUI

struct AddNewItemScreen: View {
    
    @StateObject private var viewModel: AddNewItemViewModel
    // GALLERY
    @State private var galleryImageItem: PhotosPickerItem?
    @State private var selectedGalleryImage: UIImage?
    @State private var shouldShowPhotoPicker = false
    // CAMERA
    @State private var showingPermissionAlert = false
    @State private var permissionMessage = ""
    @State private var shouldShowCamera = false
    @State private var selectedCameraImage: UIImage?
    
    @State private var shouldShowLoading = false
    
    private var rotateImageButton: some View {
        Button(
            action : {
                if let cameraImage = selectedCameraImage {
                    selectedCameraImage = cameraImage.rotate(radians: .pi / 2)
                } else if let galleryImage = selectedGalleryImage {
                    selectedGalleryImage = galleryImage.rotate(radians: .pi / 2)
                }
            },
            label: {
                Label("Rotate Image", systemImage: "rotate.right")
                    .foregroundColor(.black)
            }
        )
        .buttonStyle(.borderedProminent)
        .tint(.blue)
    }
    
    private var selectedImage: UIImage? {
        if selectedCameraImage != nil {
            return selectedCameraImage
        }
        return selectedGalleryImage
    }
    
    @ViewBuilder private var imageView: some View {
        if let selectedImage = selectedCameraImage {
            VStack {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 400)
                rotateImageButton
            }
        }
    }
    
    var body: some View {
        VStack {
            Button(
                action : {
                    shouldShowLoading = true
                    selectedGalleryImage = nil
                    checkCameraPermissions()
                },
                label: {
                    Label("Open Camera To Take Photo", systemImage: "camera")
                        .foregroundColor(.black)
                }
            )
            .buttonStyle(.borderedProminent)
            .tint(selectedCameraImage == nil ? .blue : .green)
            
            PhotosPicker(selection: $galleryImageItem, matching: .images) {
                Label("Select Photo From Gallery", systemImage: "photo")
                    .foregroundColor(.black)
            }
            .buttonStyle(.borderedProminent)
            .tint(selectedGalleryImage == nil ? .blue : .green)
            
            if let selectedGalleryImage {
                Image(uiImage: selectedGalleryImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 400)
                rotateImageButton
            }
            if let selectedCameraImage {
                Image(uiImage: selectedCameraImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 400)
                rotateImageButton
            }
            if selectedGalleryImage == nil && selectedCameraImage == nil && shouldShowLoading {
                Spacer()
                ProgressView()
            }
            Spacer()
        }
        .padding()
        .onChange(of: galleryImageItem) { item in
            Task {
                shouldShowLoading = true
                if let loaded = try? await item?.loadTransferable(type: Data.self) {
                    selectedGalleryImage = UIImage(data: loaded)
                    selectedCameraImage = nil
                } else {
                    print("Failed")
                }
                shouldShowLoading = false
            }
        }
        .fullScreenCover(isPresented: $shouldShowCamera) {
            ImagePicker(selectedImage: $selectedCameraImage)
        }
        .alert(isPresented: $showingPermissionAlert) {
            Alert(
                title: Text("Permission Required"),
                message: Text(permissionMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    init(viewModel: AddNewItemViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            shouldShowCamera = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        shouldShowCamera = true
                    } else {
                        permissionMessage = "Camera access is required to take photos."
                        showingPermissionAlert = true
                    }
                }
            }
        case .denied, .restricted:
            permissionMessage = "Camera access is required to take photos. Please enable it in Settings."
            showingPermissionAlert = true
        default:
            break
        }
    }
}


import UIKit

extension UIImage {
    
    func rotate(radians: CGFloat) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        context.rotate(by: radians)
        draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }
}
