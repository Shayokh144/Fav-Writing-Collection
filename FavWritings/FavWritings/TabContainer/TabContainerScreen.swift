//
//  TabContainerScreen.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 13/5/24.
//

import SwiftUI

struct TabContainerScreen: View {
    
    @StateObject private var writingListViewModel: WritingsListViewModel
    @StateObject private var wordSearchViewModel: WordSearchViewModel
    
    private let onTapWritingName: (WritingDetailsUIModel) -> Void
    
    var body: some View {
        TabView {
            WritingsListScreen(
                viewModel: writingListViewModel,
                onTapWritingName: onTapWritingName
            )
            .tabItem {
                Label("All Writings", systemImage: "list.bullet.rectangle")
            }
            WordSearchScreen(
                viewModel: wordSearchViewModel
            )
            .tabItem {
                Label("Word Search", systemImage: "doc.text.magnifyingglass")
            }
        }
    }
    
    init(onTapWritingName: @escaping (WritingDetailsUIModel) -> Void) {
        _writingListViewModel = StateObject(wrappedValue: WritingsListViewModel())
        _wordSearchViewModel = StateObject(wrappedValue: WordSearchViewModel())
        self.onTapWritingName = onTapWritingName
    }
}
