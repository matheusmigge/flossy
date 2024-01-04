//
//  ToothView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 02/01/24.
//

import SwiftUI

struct ToothView: View {
    
    @State var isRotating: Bool = false
    @State var isMoving: Bool = false
    var style: Style
    
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
                .frame(height: 220)
                .rotationEffect(.degrees(isRotating ? -10 : 10))
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isRotating)
                .offset(x: isMoving ? 0 : -900)
                .animation(.spring(.bouncy, blendDuration: 3), value: isMoving)
        }
        .ignoresSafeArea()
        .onAppear {
            isRotating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                isMoving = true
            }
        }
        .rotationEffect(.degrees(Double.random(in: 0...360)))
    }
}

#Preview {
    ToothView(style: .pink)
}
