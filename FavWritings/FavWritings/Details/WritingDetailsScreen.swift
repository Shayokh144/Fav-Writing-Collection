//
//  WritingDetailsScreen.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 7/5/24.
//

import SwiftUI

struct WritingDetailsScreen: View {
    
    private let onTapBack: () -> Void
    private let uiModel: WritingDetailsUIModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    init(onTapBack: @escaping () -> Void, uiModel: WritingDetailsUIModel) {
        self.onTapBack = onTapBack
        self.uiModel = uiModel
    }
}


struct WritingDetailsUIModel {
    
    let contentName: String
    let content: String
    let writerName: String
}
