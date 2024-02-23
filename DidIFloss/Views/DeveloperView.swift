//
//  DeveloperView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 22/02/24.
//

import SwiftUI
import UIKit

struct DeveloperView: View {
    
    @ObservedObject var feedbackGenerator = UserFeedbackManager.shared
    
    var body: some View {
        List {
            Section {
                Picker("Celebration", selection: $feedbackGenerator.preferredCelebrationFeedbackType) {
                    Text("Tuc")
                        .tag(HapticFeedbackOption.success)
    
                    Text("Tuc Tuc")
                        .tag(HapticFeedbackOption.warning)
                    
                    Text("Tuc Tuc Tuc")
                        .tag(HapticFeedbackOption.error)
                    
                    Text("None")
                            .tag(HapticFeedbackOption.none)
                }
                
                Picker("Deletion", selection: $feedbackGenerator.preferredDeletionFeedbackType) {
                    Text("Tuc")
                        .tag(HapticFeedbackOption.success)
    
                    Text("Tuc Tuc")
                        .tag(HapticFeedbackOption.warning)
                    
                    Text("Tuc Tuc Tuc")
                        .tag(HapticFeedbackOption.error)
                    
                    Text("None")
                            .tag(HapticFeedbackOption.none)

                }
                
            } header: {
                Text("Vibrations")
            } footer: {
                Text("Chose a vibration style to be triggered for each case")
            }
            
        }
    }
}

#Preview {
    DeveloperView()
}
