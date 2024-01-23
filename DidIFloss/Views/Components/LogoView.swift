//
//  LogoView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 23/01/24.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
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
            
            Spacer()
        }
    }
}

#Preview {
    LogoView()
}
