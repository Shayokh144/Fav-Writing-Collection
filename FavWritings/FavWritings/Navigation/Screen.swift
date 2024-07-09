//
//  Screen.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 13/5/24.
//

import UIKit
import Foundation

enum Screen {

    case addImage(AddImageViewModel, onSelectImage: (UIImage) -> Void)
    case splash
    case tabContainer
    case writingsList(WritingsListViewModel)
    case writingsDetails(WritingDetailsUIModel)
    case wordSearch(WordSearchViewModel)
}

