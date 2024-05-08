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
    
//    private var contentArray: [String] {
//        let dataArray = uiModel.content.components(separatedBy: "\n")
//        // Filter out empty strings
//        let filteredArray = dataArray.filter { !$0.isEmpty }
//        return filteredArray
//    }
    
    var body: some View {
        VStack {
            Text(uiModel.contentName)
                .padding(.bottom, 4.0)
            Text(uiModel.writerName)
                .padding(.bottom, 8.0)
            ScrollView {
//                ForEach(contentArray.indices, id: \.self) { index in
//                    Text(contentArray[index])
//                        .padding(.bottom, 8.0)
//                }
                Text(uiModel.content)
            }
        }
    }
    
    init(onTapBack: @escaping () -> Void, uiModel: WritingDetailsUIModel) {
        self.onTapBack = onTapBack
        self.uiModel = uiModel
    }
}
