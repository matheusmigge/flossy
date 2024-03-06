//
//  LaunchScreenView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 01/01/24.
//

import SwiftUI

struct LaunchScreenView: View {
    
    var animationOver: () -> Void
    
    var body: some View {
        ZStack {
            Color.flossLightYellow
            
            BackgroundView()
            
            welcomeLabel
            
        }
        .ignoresSafeArea()
        .onAppear {
            startAnimation()
        }
    }
    
    private var welcomeLabel: some View {

        LogoView()
    }
    
    private func startAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            animationOver()
        }
    }
}


#Preview {
    LaunchScreenView(animationOver: {})
}
