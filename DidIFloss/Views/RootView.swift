//
//  RootView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 24/01/24.
//

import SwiftUI

struct RootView: View {
    
    @State var isShowingLaunchScreen: Bool = true
    
    func viewDidApper() {
        
        withAnimation(.easeInOut(duration: 1)) {
            isShowingLaunchScreen = false
            
        }
    }
    
    var body: some View {
        ZStack {
            ContentView()
            
            if isShowingLaunchScreen {
                LaunchScreenView(animationOver: {
                    viewDidApper()
                })
                
            }
        }
    }
}

#Preview {
    RootView()
}
