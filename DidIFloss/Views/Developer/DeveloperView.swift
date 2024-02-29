//
//  DeveloperView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 22/02/24.
//

import SwiftUI
import UIKit

struct DeveloperView: View {
    
    @ObservedObject var feedbackGenerator = HapticsManager.shared
    
    var body: some View {
        List {
            Section {
                Picker("Celebration", selection: $feedbackGenerator.preferredCelebrationFeedbackType) {
                    Text("Success - Tuc")
                        .tag(HapticFeedbackOption.short)
    
                    Text("Warming - Tuc Tuc")
                        .tag(HapticFeedbackOption.medium)
                    
                    Text("Error - Tuc Tuc Tuc")
                        .tag(HapticFeedbackOption.long)
                    
                    Text("None")
                            .tag(HapticFeedbackOption.none)
                }
                
                Picker("Deletion", selection: $feedbackGenerator.preferredDeletionFeedbackType) {
                    Text("Success - Tuc")
                        .tag(HapticFeedbackOption.short)
    
                    Text("Warming - Tuc Tuc")
                        .tag(HapticFeedbackOption.medium)
                    
                    Text("Error - Tuc Tuc Tuc")
                        .tag(HapticFeedbackOption.long)
                    
                    Text("None")
                            .tag(HapticFeedbackOption.none)
                }
                
            } header: {
                Text("Vibrations")
            } footer: {
                Text("Chose a vibration style to be triggered for each case")
            }
            
        }
        .pickerStyle(.menu)
    }
}

#Preview {
    DeveloperView()
}
