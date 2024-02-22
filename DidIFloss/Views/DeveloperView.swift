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
                        .tag(FeedbackOption.success)
    
                    Text("Tuc Tuc")
                        .tag(FeedbackOption.warning)
                    
                    Text("Tuc Tuc Tuc")
                        .tag(FeedbackOption.error)
                    Text("None")
                            .tag(FeedbackOption.none)
                }
                
                Picker("Deletion", selection: $feedbackGenerator.preferredDeletionFeedbackType) {
                    Text("Tuc")
                        .tag(FeedbackOption.success)
    
                    Text("Tuc Tuc")
                        .tag(FeedbackOption.warning)
                    
                    Text("Tuc Tuc Tuc")
                        .tag(FeedbackOption.error)
                    Text("None")
                            .tag(FeedbackOption.none)

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
