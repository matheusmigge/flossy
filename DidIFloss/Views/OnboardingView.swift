//
//  WellcomeView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 01/02/24.
//

import SwiftUI

struct OnboardingRowModel {
    let iconString: String
    let title: String
    let message: String
    
    
    struct WellcomeFeatures {
        static let calendar = OnboardingRowModel(iconString: "calendar",
                                                 title: "Keep track of your floss routine",
                                                 message: "You can log a record every time you floss so you never miss your last floss date.")
        
        static let streak = OnboardingRowModel(iconString: "checkmark.seal.fill",
                                               title: "Challenge yourself",
                                               message: "For how long can you keep your floss streak? Start today you record!")
        
        static let notifications = OnboardingRowModel(iconString: "alarm",
                                                      title: "What about a reminder?",
                                                      message: "We know it's hard to floss everyday. We use notifications to remind you to floss if you didn't log for a while.")
        
    }
    
}


struct OnboardingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 50){
            
            Text("Wellcome to Did I Floss")
                .font(.largeTitle)
                .monospaced()
                .padding()
            
            VStack(spacing: 30) {
                createRowView(feature: OnboardingRowModel.WellcomeFeatures.calendar)
                
                createRowView(feature: OnboardingRowModel.WellcomeFeatures.streak)
                
                createRowView(feature: OnboardingRowModel.WellcomeFeatures.notifications)
                
            }
            
            
            Button {
                dismiss()
            } label: {
                Text("Continue")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 30)
                
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .presentationBackgroundInteraction(.enabled)
        .presentationCornerRadius(25)
        .presentationBackground(Material.regular)
    }
    
    
    func createRowView(feature: OnboardingRowModel) -> some View {
        VStack {
            HStack {
                Image(systemName: feature.iconString)
                    .resizable()
                    .frame(width: 35, height: 35)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(feature.title)
                        .font(.headline)
                    
                    Text(feature.message)
                        .font(.callout)
                        .fontWeight(.light)
                        .foregroundStyle(.primary)
                    
                }
                .multilineTextAlignment(.leading)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
