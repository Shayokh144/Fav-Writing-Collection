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
        var urlDict: [String: Bool] = [:]
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.onFinishedLoading()
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.onStartLoading()
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.onFinishedLoading()
        }
        
        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            if let urlValue = navigationAction.request.url?.absoluteString {
                if urlDict[urlValue] == nil {
                    urlDict[urlValue] = true
                }
            }
            decisionHandler(.allow)
        }
    }
    
    @Binding var url: URL?
    let webView: WKWebView
    let onFinishedLoading: () -> Void
    let onStartLoading: () -> Void

    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = url, context.coordinator.urlDict[url.absoluteString] == nil {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    init(
        url: Binding<URL?>,
        webView: WKWebView,
        onFinishedLoading: @escaping () -> Void,
        onStartLoading: @escaping () -> Void
    ) {
        _url = url
        self.webView = webView
        self.onFinishedLoading = onFinishedLoading
        self.onStartLoading = onStartLoading
    }
}

