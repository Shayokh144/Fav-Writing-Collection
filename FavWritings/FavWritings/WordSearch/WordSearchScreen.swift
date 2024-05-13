//
//  WordSearchScreen.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 13/5/24.
//

import Combine
import SwiftUI
import WebKit

struct WordSearchScreen: View {
    
    @StateObject private var viewModel: WordSearchViewModel
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var copiedWord: String = ""
    @State private var isPresentWebView = false
    
    private var suffixView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.suffixMatchWords, id: \.self) { word in
                    Text(word)
                        .padding(.bottom, 2.0)
                        .onTapGesture(count: 2) {
                            handleDoubleTap(for: word)
                        }
                        .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 30) {
                            processCopyText(word: word)
                        } onPressingChanged: { _ in
                            
                        }
                }
            }
        }
    }
    
    private var prefixView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.prefixMatchWords, id: \.self) { word in
                    Text(word)
                        .padding(.bottom, 2.0)
                        .onTapGesture(count: 2) {
                            handleDoubleTap(for: word)
                        }
                        .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 30) {
                            processCopyText(word: word)
                        } onPressingChanged: { _ in
                            
                        }
                }
            }
        }
    }
    
    private var copyTextToast: some View {
        Text("\(copiedWord) copied to clipboard")
            .foregroundStyle(Color.black)
            .padding(8.0)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.7))
            .cornerRadius(16.0)
    }
    
    private var contentView: some View {
        VStack {
            switch viewModel.state {
                case .loading:
                    ProgressView()
                case .loaded:
                    VStack {
                        if !copiedWord.isEmpty {
                            copyTextToast
                        }
                        TextField("Set word count", text: $viewModel.maxWordCount)
                            .padding(.horizontal, 8.0)
                            .padding(.vertical, 6.0)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10.0)
                        HStack {
                            prefixView
                            Spacer()
                            suffixView
                        }
                        .padding(.top, 8.0)
                    }
                    .animation(.linear, value: copiedWord.isEmpty)
                case .error:
                    Text("Error")
                    Button("Try again", action: viewModel.tryAgain)
                    
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Search Bengali Word")
                .searchable(
                    text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "write word here"
                )
                .padding()
                .animation(.linear, value: isPresentWebView)
                .sheet(isPresented: $isPresentWebView) {
                    NavigationStack {
                        if let url = viewModel.wordMeaningURL {
                            webView(url: url)
                        } else {
                            Text("Wrong URL")
                        }
                    }
                    .presentationDetents([.fraction(0.7)])
                }
        }
        .onAppear {
            viewModel.viewAppear()
            stopTimer()
        }
        .onReceive(timer) { value in
            copiedWord = ""
            stopTimer()
        }
    }
    
    init(viewModel: WordSearchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private func webView(url: URL) -> some View {
        let webView = WKWebView()
        return VStack {
            HStack {
                Button(
                    action: {
                        webView.goBack()
                    },
                    label: {
                        Text("Back")
                            .padding(4.0)
                    }
                )
                Spacer()
                Text("Word Meaning")
                Spacer()
                Button(
                    action: {
                        webView.goForward()
                    },
                    label: {
                        Text("Forward")
                            .padding(4.0)
                    }
                )
            }
            .padding(8.0)
            WebView(url: url, webView: webView)
        }
        .ignoresSafeArea()
    }
    
    private func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 2.0, on: .main, in: .common).autoconnect()
    }
    
    private func processCopyText(word: String) {
        UIPasteboard.general.string = word
        copiedWord = word
        startTimer()
    }
    
    private func handleDoubleTap(for word: String) {
        viewModel.onSelectWord(word: word)
        isPresentWebView = true
    }
}

