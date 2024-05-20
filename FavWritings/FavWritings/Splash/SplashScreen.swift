//
//  SplashScreen.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 14/5/24.
//

import SwiftUI

struct SplashScreen: View {
    
    private let onFinishSplashAnimation: () -> Void
    @State private var logoOpacity: Double = 0.0
    
    var body: some View {
        ZStack {
            Image("launchScreeenImage")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Image("penInkLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 180)
                .opacity(logoOpacity)
                .animation(
                    .easeIn(duration: 1.0),
                    value: logoOpacity
                )
                .onAppear {
                    logoOpacity = 1.0
                }
                .task {
                    await finishAnimating()
                }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    init(onFinishSplashAnimation: @escaping () -> Void) {
        self.onFinishSplashAnimation = onFinishSplashAnimation
    }
    
    @MainActor 
    // Without main actor onFinishSplashAnimation will use background thread which will
    // cause running navigation related code to background thread, that means UI code will
    // run from background thread
    private func finishAnimating() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        onFinishSplashAnimation()
    }
}
