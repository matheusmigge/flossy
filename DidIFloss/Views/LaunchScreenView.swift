//
//  HomeScreenView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 01/01/24.
//

import SwiftUI

struct LaunchScreenView: View {
    
    @State private var isAnimating: Bool = false
    var animationOver: () -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            homeScreenTextContent
                .scaleEffect(isAnimating ? 40 : 1)
            
        }
        .ignoresSafeArea()
        .onAppear {
            startAnimation()
        }
    }
    
    private var homeScreenTextContent: some View {
        VStack(spacing: -50) {
            Text("did I")
            Text("floss?")
        }
        .font(.custom(Constants.FontNames.borel, size: 60))
        .padding(30)
        .padding(.bottom, -20)
        .background(Color.flossLightYellow)
        .foregroundStyle(Color.black)
        .multilineTextAlignment(.center)
        .rotationEffect(.degrees(7))
        .shadow(color: Color.black.opacity(0.5), radius: 5)
        
    }
    
    private func startAnimation() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 1)) {
                    isAnimating = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        animationOver()
                    }
                }
            }
        }
}

#Preview {
    LaunchScreenView(animationOver: {})
}
