//
//  AddNewItemScreen.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 1/7/24.
//

import SwiftUI

struct AddNewItemScreen: View {
    
    @StateObject private var viewModel: AddNewItemViewModel
    
    var body: some View {
        Text("ADD NEW")
    }
    
    init(viewModel: AddNewItemViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}
