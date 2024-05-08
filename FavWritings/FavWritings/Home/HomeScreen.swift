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
                ForEach(viewModel.names.indices, id: \.self) { index in
                    Button(
                        action: {
                            
                        },
                        label: {
                            Text(viewModel.names[index])
                                .foregroundStyle(Color.black)
                                .frame(maxWidth: .infinity)
                                .padding(8.0)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10.0)
                        }
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            nameListView
                .padding()
        }
        .padding()
    }
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}
