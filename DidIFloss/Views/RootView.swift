//
//  RootView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 24/01/24.
//

import SwiftUI

struct RootView: View {
    
    @State var state: Content = .launchScreen
    
    enum Content {
        case content, launchScreen
    }
    
    func lauchScreenAnimationDone() {
        withAnimation(.smooth) {
            state = .content
        }
    }
    
    var body: some View {
        ZStack {
            switch state {
            case .content:
                HomeView()
            case .launchScreen:
                LaunchScreenView {
                    lauchScreenAnimationDone()
                }
            }
        }
    }
}

#Preview {
    RootView()
}
