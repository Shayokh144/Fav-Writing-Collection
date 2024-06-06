//
//  WebView.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 13/5/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.onFinishedLoading()
        }
    }
    
    let url: URL
    let webView: WKWebView
    let onFinishedLoading: () -> Void

    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {

        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    init(
        url: URL,
        webView: WKWebView,
        onFinishedLoading: @escaping () -> Void
    ) {
        self.url = url
        self.webView = webView
        self.onFinishedLoading = onFinishedLoading
    }
}

