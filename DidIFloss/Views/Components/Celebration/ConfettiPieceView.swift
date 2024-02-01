//
//  ConfettiPieceView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 01/02/24.
//

import SwiftUI

struct ConfettiPieceView: View {
    
    static let confettiColors: [Color] = [.red, .blue, .green, .orange, .purple, .yellow]
    
    var color: Color
    var initialRotation: Double
    var size: CGSize
    
    @State var isAnimating: Bool = false
    
    init(color: Color = Self.confettiColors.randomElement()!,
         rotation: Double = Double.random(in: -180...180),
         size: CGSize = CGSize(width: CGFloat.random(in: 10...20),
                               height: CGFloat.random(in: 20...25))) {
        self.color = color
        self.initialRotation = rotation
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .frame(width: size.width, height: size.height)
                .rotationEffect(.degrees(isAnimating ? Double.random(in: 0...360) : initialRotation))
        }
        .onAppear {
            withAnimation(.easeInOut(duration: Double.random(in: 1...2)).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
            
        }
    }
}

#Preview {
    ConfettiPieceView()
}
