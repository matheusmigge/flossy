//
//  LogoView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 23/01/24.
//

import SwiftUI
import FlossyDesignSystem

struct LogoView: View {
    var body: some View {
        VStack(spacing: 220) {
            
            Text("flossy")
                .font(FlossyFonts.borel(size: 60))
                .padding(30)
                .padding(.top, 30)
                .background(FlossyColors.logoBackground)
                .foregroundStyle(Color.primary)
                .multilineTextAlignment(.center)
                .rotationEffect(.degrees(7))
                .shadow(color: Color.black.opacity(0.5), radius: 5)
        }
    }
}

#Preview {
    LogoView()
}
