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
    private let onTapAddImage: () -> Void
    
    private var addFromImageButton: some View {
        Button(
            action : onTapAddImage,
            label: {
                Label("Add from image", systemImage: "photo")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
            }
        )
        .buttonStyle(.borderedProminent)
        .tint(.blue)
    }
    
    private var addManualTextButton: some View {
        Button(
            action : {
                
            },
            label: {
                Label("Add manual text", systemImage: "pencil.tip.crop.circle.badge.plus")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
            }
        )
        .buttonStyle(.borderedProminent)
        .tint(.blue)
    }
    
    @ViewBuilder private var imageView: some View {
        if let image = viewModel.selectedImage {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 400)
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Add new item")
                .font(.headline)
                .padding(.bottom)
            Spacer()
            addFromImageButton
            addManualTextButton
            imageView
            Spacer()
        }
        .padding()
    }
    
    init(viewModel: AddNewItemViewModel, onTapAddImage: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onTapAddImage = onTapAddImage
    }
}
