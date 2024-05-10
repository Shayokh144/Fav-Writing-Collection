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
    private let contentArray: [String]
    private let maxPadding: CGFloat = 64.0
    @State private var isRaw = false
    @State private var isLoading = true
    
    private var content: some View {
        VStack {
            ScrollView {
                if isRaw {
                    Text(uiModel.content)
                } else {
                    VStack(alignment: .leading) {
                        ForEach(contentArray.indices, id: \.self) { index in
                            if !contentArray[index].isEmpty {
                                Text(contentArray[index])
                                    .padding(.bottom, getPadding(for: index))
                            }
                        }
                    }
                }
            }
            Spacer()
            Button(
                action: {
                    isRaw.toggle()
                },
                label: {
                    Text(isRaw ? "Furnished View" : "Raw View")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 14.0, weight: .bold))
                        .padding(8.0)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10.0)
                }
            )
            .buttonStyle(.plain)
            .padding(.top)
        }
    }
    
    var body: some View {
        VStack {
            Text(uiModel.contentName)
                .font(.system(size: 18.0, weight: .bold))
                .padding(.bottom, 4.0)
            Text(uiModel.writerName)
                .font(.system(size: 14.0, weight: .bold))
                .padding(.bottom, 8.0)
            Spacer()
            if isLoading {
                ProgressView()
                Spacer()
            } else {
                content
            }
        }
        .animation(.linear, value: isRaw)
        .task {
            await showLoading()
        }
    }
    
    init(onTapBack: @escaping () -> Void, uiModel: WritingDetailsUIModel) {
        self.onTapBack = onTapBack
        self.uiModel = uiModel
        contentArray = uiModel.content.components(separatedBy: "\n")
    }
    
    private func getPadding(for index: Int) -> CGFloat {
        if index >= contentArray.count - 1 {
            // last element
            return 32.0
        }
        var padding: CGFloat = 0.0
        var startIndex = index + 1
        let endIndex = contentArray.count - 1
        var multiplayer = 1.0
        while startIndex <= endIndex {
            if !contentArray[startIndex].isEmpty {
                break
            }
            padding += (4.0 * multiplayer)
            multiplayer += 1
            startIndex += 1
        }
        return min(padding, maxPadding)
    }
    
    private func showLoading() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isLoading = false
    }
}
