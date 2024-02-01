//
//  CelebrationView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 01/02/24.
//

import SwiftUI


struct CelebrationView: View {
    
    let confettiCount = 30
    @State var isAnimating: Bool = false
    
    weak var delegate: CelebrationViewDelegate?
    
    var body: some View {
        ZStack {
            ForEach(0..<confettiCount, id: \.self) { index in
                ConfettiPieceView()
                    .offset(x: isAnimating ? CGFloat.random(in: -250...250) : -0,
                            y: isAnimating ?  CGFloat.random(in: -350...350) : 400)
                    .rotationEffect(isAnimating ? .degrees(Double.random(in: -45...45)) : .degrees(0))
                
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 2)) {
                isAnimating = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                delegate?.didCompleteAnimation()
            }
        }
    }
}

#Preview {
    CelebrationView()
}
