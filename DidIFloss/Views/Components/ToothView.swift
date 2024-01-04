//
//  ToothView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 02/01/24.
//

import SwiftUI

struct ToothView: View {
    
    @State var isRotating: Bool = false

    var style: Style
    var size: CGFloat
    
    enum Style: String {
        case pink
        case yellow
        var imageName: String {
            switch self {
            case .pink:
                Constants.ImageNames.toothPink
            case .yellow:
                Constants.ImageNames.toothYellow
            }
        }
    }
    
    var body: some View {
        ZStack {
            
            Image(style.imageName)
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
