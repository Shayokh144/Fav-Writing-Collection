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
    private let onTapAddImage: () -> Void
    
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
                viewModel: addNewItemViewModel, 
                onTapAddImage: onTapAddImage
            )
            .tabItem {
                Label("Add new", systemImage: "note.text.badge.plus")
            }
        }
    }
    
    init(
        writingListViewModel: WritingsListViewModel,
        wordSearchViewModel: WordSearchViewModel,
        addNewItemViewModel: AddNewItemViewModel,
        onTapWritingName: @escaping (WritingDetailsUIModel) -> Void,
        onTapAddImage: @escaping () -> Void
    ) {
        _writingListViewModel = StateObject(wrappedValue: writingListViewModel)
        _wordSearchViewModel = StateObject(wrappedValue: wordSearchViewModel)
        _addNewItemViewModel = StateObject(wrappedValue: addNewItemViewModel)
        self.onTapWritingName = onTapWritingName
        self.onTapAddImage = onTapAddImage
    }
}
