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
    @StateObject private var addNewItemViewModel: AddNewItemViewModel
    
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
            AddNewItemScreen(
                viewModel: addNewItemViewModel
            )
            .tabItem {
                Label("Add new", systemImage: "note.text.badge.plus")
            }
        }
    }
    
    init(onTapWritingName: @escaping (WritingDetailsUIModel) -> Void) {
        _writingListViewModel = StateObject(wrappedValue: WritingsListViewModel())
        _wordSearchViewModel = StateObject(wrappedValue: WordSearchViewModel())
        _addNewItemViewModel = StateObject(wrappedValue: AddNewItemViewModel())
        self.onTapWritingName = onTapWritingName
    }
}
