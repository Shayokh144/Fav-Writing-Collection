//
//  HomeScreen.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 7/5/24.
//

import SwiftUI

struct HomeScreen: View {
    
    @StateObject private var viewModel: HomeViewModel
    
    private var nameListView: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.uiModel.indices, id: \.self) { index in
                    NavigationLink(
                        destination: WritingDetailsScreen(
                            onTapBack: {},
                            uiModel: viewModel.uiModel[index]
                        )
                    ) {
                        Text(viewModel.uiModel[index].contentName)
                            .foregroundStyle(Color.purple)
                            .frame(maxWidth: .infinity)
                            .padding(8.0)
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(10.0)
                            .padding(.bottom)
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            nameListView
                .padding()
        }
        .padding()
    }
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}
