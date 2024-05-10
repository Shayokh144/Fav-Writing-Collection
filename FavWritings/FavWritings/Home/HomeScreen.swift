//
//  HomeScreen.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 7/5/24.
//

import SwiftUI

struct HomeScreen: View {
    
    @StateObject private var viewModel: HomeViewModel
    @State private var searchNameText = ""
    
    var searchNameResults: [WritingDetailsUIModel] {
        if searchNameText.isEmpty {
            return viewModel.uiModel
        } else {
            return viewModel.uiModel.filter {
                $0.contentName.lowercased().contains(searchNameText.lowercased())
            }
        }
    }
    
    private var nameListView: some View {
        ScrollView {
            VStack {
                ForEach(searchNameResults.indices, id: \.self) { index in
                    NavigationLink(
                        destination: WritingDetailsScreen(
                            onTapBack: {},
                            uiModel: searchNameResults[index]
                        )
                    ) {
                        Text(searchNameResults[index].contentName)
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
    
    private var searchTextField: some View {
        TextField("Write name here to search", text: $searchNameText)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Writings")
                    .font(.headline)
                    .padding(.bottom)
                searchTextField
                    .foregroundStyle(.purple)
                    .textFieldStyle(.roundedBorder)
                nameListView
                    .padding(.vertical)
            }
        }
        .padding()
    }
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}
