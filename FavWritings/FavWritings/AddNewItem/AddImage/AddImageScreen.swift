//
//  AddImageScreen.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 10/7/24.
//

import SwiftUI
import PhotosUI

struct AddImageScreen: View {
    
    @StateObject private var viewModel: AddImageViewModel
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
    
    private let onTapUseImage: (UIImage) -> Void
    
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
                    .frame(maxWidth: .infinity)
            }
        )
        .buttonStyle(.borderedProminent)
        .tint(.blue)
    }
    
    private var useImageButton: some View {
        Button(
            action : {
                if let image = selectedImage {
                    onTapUseImage(image)
                } else {
                    // TODO: Show error
                }
            },
            label: {
                Label("Use this image", systemImage: "paperplane.circle.fill")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
        )
        .buttonStyle(.borderedProminent)
        .tint(.green)
    }
    
    private var selectedImage: UIImage? {
        if selectedCameraImage != nil {
            return selectedCameraImage
        }
        return selectedGalleryImage
    }
    
    @ViewBuilder private var imageView: some View {
        if let image = selectedImage {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 400)
                rotateImageButton
                useImageButton
            }
        }
    }
    
    private var openCameraButton: some View {
        Button(
            action : {
                shouldShowLoading = true
                selectedGalleryImage = nil
                checkCameraPermissions()
            },
            label: {
                Label("Open Camera To Take Photo", systemImage: "camera")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
            }
        )
        .disabled(shouldShowLoading)
        .buttonStyle(.borderedProminent)
        .tint(selectedCameraImage == nil ? .blue : .green)
    }
    
    private var openGalleryButton: some View {
        PhotosPicker(selection: $galleryImageItem, matching: .images) {
            Label("Select Photo From Gallery", systemImage: "photo")
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
        }
        .disabled(shouldShowLoading)
        .buttonStyle(.borderedProminent)
        .tint(selectedGalleryImage == nil ? .blue : .green)
    }
    
    var body: some View {
        VStack {
            Text("Select Image")
                .font(.headline)
                .padding(.bottom)
            openCameraButton
            openGalleryButton
            imageView
            if selectedImage == nil && shouldShowLoading {
                Spacer()
                ProgressView()
            }
            Spacer()
        }
        .padding()
        .onChange(of: shouldShowCamera) {
            shouldShowLoading = shouldShowCamera
        }
        .onChange(of: galleryImageItem) {
            Task {
                shouldShowLoading = true
                if let loaded = try? await galleryImageItem?.loadTransferable(type: Data.self) {
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
    
    init(
        viewModel: AddImageViewModel,
        onTapUseImage: @escaping (UIImage) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onTapUseImage = onTapUseImage
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
