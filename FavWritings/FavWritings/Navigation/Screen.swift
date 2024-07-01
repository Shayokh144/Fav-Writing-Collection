//
//  Screen.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 13/5/24.
//

import Foundation

enum Screen {

    case addNewItem(AddNewItemViewModel)
    case splash
    case tabContainer
    case writingsList(WritingsListViewModel)
    case writingsDetails(WritingDetailsUIModel)
    case wordSearch(WordSearchViewModel)
}

