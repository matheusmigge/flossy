//
//  HomeScreenView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 01/01/24.
//

import SwiftUI

struct HomeScreenView: View {
    
    enum Contents {
        case home,content
    }
    
    @State var currentContent: Contents = .home
    
    var body: some View {
        GeometryReader { screen in
            NavigationView {
                ZStack {
                    
                    BackgroundView()
                    
                    switch currentContent {
                    case .home:
                        homeScreenTextContent
                    case .content:
                        ContentView()
                            .frame(
                                width: screen.size.width * 0.8,
                                height: screen.size.height * 0.8)
                    }
                }
            }
        }
    }
    
    var homeScreenTextContent: some View {
        
        VStack(spacing: 220) {
            Spacer()
            
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
            
            Button {
                withAnimation(.linear(duration: 1)) {
                    self.currentContent = .content
                }
            } label: {
                Text("Enter")
                    .font(.system(size: 25))
                    .fontWeight(.black)
                    .foregroundStyle(Color.black)
                    .padding(.horizontal,80)
                    .padding(.vertical,20)
                    .background(Color.flossLightYellow)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.5), radius: 5)
            }
            .buttonStyle(.plain)
            
            Spacer()
        }
    }
}

#Preview {
    HomeScreenView()
}
