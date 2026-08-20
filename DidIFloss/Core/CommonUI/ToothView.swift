//
//  ToothView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 02/01/24.
//

import SwiftUI
import FlossyDesignSystem

struct ToothView: View {
    
    @State var isRotating: Bool = false

    var style: Style
    var size: CGFloat
    
    enum Style: String {
        case pink
        case yellow
        var image: Image {
            switch self {
            case .pink:
                return FlossyImages.toothPink
            case .yellow:
                return FlossyImages.toothYellow
            }
        }
    }
    
    var body: some View {
        ZStack {
            
            style.image
                .resizable()
                .scaledToFit()
                .frame(height: size)
                .rotationEffect(.degrees(isRotating ? -30 : 30))
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isRotating)
        }
        .ignoresSafeArea()
        .onAppear {
            isRotating = true
        }
        .rotationEffect(.degrees(Double.random(in: 0...360)))
    }
}

#Preview {
    ToothView(style: .pink, size: 120)
}
