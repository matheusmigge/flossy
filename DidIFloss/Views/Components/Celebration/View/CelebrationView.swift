//
//  CelebrationView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 01/02/24.
//

import SwiftUI


struct CelebrationView: View {
    
    private let confettiCount: Int
    @State var isAnimating: Bool = false
    
    weak var delegate: CelebrationViewDelegate?
    
    init(confettiCount: Int = 30, delegate: CelebrationViewDelegate? = nil) {
        self.confettiCount = confettiCount
        self.delegate = delegate
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<confettiCount, id: \.self) { index in
                    ConfettiPieceView()
                        .offset(x: isAnimating ? CGFloat.random(in: geo.size.width * 0.1...geo.size.width * 0.9) : geo.size.width / 2,
                                y: isAnimating ?  CGFloat.random(in: geo.size.height*0.1...geo.size.height*0.75) : geo.size.height + 10)
                        .rotationEffect(isAnimating ? .degrees(Double.random(in: -15...15)) : .degrees(0))
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.spring(duration: 2)) {
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
