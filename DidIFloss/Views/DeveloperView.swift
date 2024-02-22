//
//  DeveloperView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 22/02/24.
//

import SwiftUI

struct DeveloperView: View {
    
    var feedbackGenerator = UserFeedbackManager()
    
    var body: some View {
        List {
            Section("Vibrations") {
                Button {
                    feedbackGenerator.vibrateDevice(type: .success)
                } label: {
                    Text("Success")
                }
                
                Button {
                    feedbackGenerator.vibrateDevice(type: .error)
                } label: {
                    Text("Error")
                }
                
                Button {
                    feedbackGenerator.vibrateDevice(type: .warning)
                } label: {
                    Text("Warming")
                }
            }
  
        }
    }
}

#Preview {
    DeveloperView()
}
