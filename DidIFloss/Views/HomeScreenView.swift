//
//  HomeScreenView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 01/01/24.
//

import SwiftUI

struct HomeScreenView: View {
    
    var body: some View {
        
        NavigationView {
            ZStack {
                
                Color.flossSkyBlue
                
                toothDeterminedPositions
                
                homeScreenTextContent
                
            }
            .ignoresSafeArea()
        }
    }
    
    var homeScreenTextContent: some View {
        
        VStack {
            Spacer()
            
            VStack(spacing: -50) {
                Text("did I")
                Text("floss?")
            }
            .font(.custom(Constants.FontNames.borel, size: 70))
            .padding(30)
            .padding(.bottom, -20)
            .background(Color.flossLightYellow)
            .foregroundStyle(Color.black)
            .multilineTextAlignment(.center)
            .rotationEffect(.degrees(7))
            .shadow(color: Color.primary.opacity(0.5), radius: 5)
            
            Spacer()
            
            NavigationLink {
                ContentView()
            } label: {
                Text("Enter")
                    .font(.system(size: 25))
                    .fontWeight(.black)
                    .foregroundStyle(Color.flossSkyBlue)
                    .padding(.horizontal,80)
                    .padding(.vertical,20)
                    .background(Color.flossLightYellow)
                    .cornerRadius(20)
                    .shadow(color: Color.flossLightYellow, radius: 5)
            }
            .buttonStyle(.plain)
            
            
            Spacer()
        }
    }
    
    var toothDeterminedPositions: some View {
        ZStack {
            ToothView(style: .pink)
                .offset(x: -170,y: -340)
            ToothView(style: .yellow)
                .offset(x: 70,y: -350)
            ToothView(style: .pink)
                .offset(x: 210,y: -280)
            
            ToothView(style: .pink)
                .offset(x: -210,y: -150)
            ToothView(style: .yellow)
                .offset(x: 220,y: -50)
            
            ToothView(style: .yellow)
                .offset(x: -140,y: 80)
            ToothView(style: .pink)
                .offset(x: 140,y: 110)
            
            ToothView(style: .yellow)
                .offset(x: -220,y: 220)
            ToothView(style: .yellow)
                .offset(x: 200,y: 240)
            
            ToothView(style: .pink)
                .offset(x: -110,y: 360)
            ToothView(style: .pink)
                .offset(x: 80,y: 400)
        }
    }
}

#Preview {
    HomeScreenView()
}
