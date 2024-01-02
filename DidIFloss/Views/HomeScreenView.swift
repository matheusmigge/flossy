//
//  HomeScreenView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 01/01/24.
//

import SwiftUI

struct HomeScreenView: View {
    
    var body: some View {
        
        ZStack {
            Color.flossSkyBlue
            
            homeScreenImageContent
            
            homeScreenTextContent
        }
        .ignoresSafeArea()
    }
    
    var homeScreenTextContent: some View {
        
        VStack {
            Spacer()
            
            VStack(spacing: -60) {
                Text("did I")
                Text("floss?")
            }
            .font(.custom(Constants.FontNames.borel, size: 90))
            .foregroundStyle(Color.flossLightYellow)
            .multilineTextAlignment(.center)
            .shadow(color: Color.black, radius: 2, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
            .shadow(color: .flossLightYellow, radius: 10, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
            
            Spacer()
            
            Button {
                
            } label: {
                Text("Entrar")
                    .font(.system(size: 30))
                    .fontWeight(.black)
                    .foregroundStyle(Color.flossSkyBlue)
                    .padding(.horizontal,60)
                    .padding(.vertical,15)
                    .background(Color.flossLightYellow)
                    .cornerRadius(20)
                    .shadow(color: Color.flossLightYellow.opacity(0.5), radius: 5, x: 0, y: 0)
            }
            .buttonStyle(.plain)
            
            
            Spacer()
        }
    }
    
    var homeScreenImageContent: some View {
        ZStack {
            ToothView(style: .pink)
                .offset(x: -170,y: -290)
            ToothView(style: .yellow)
                .offset(x: 70,y: -350)
            ToothView(style: .pink)
                .offset(x: 200,y: -230)

            ToothView(style: .pink)
                .offset(x: -230,y: -100)
            ToothView(style: .yellow)
                .offset(x: 220,y: -50)
            
            ToothView(style: .yellow)
                .offset(x: -100,y: 100)
            ToothView(style: .pink)
                .offset(x: 100,y: 60)
            
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
