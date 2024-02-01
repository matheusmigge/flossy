//
//  WellcomeView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 01/02/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 50){
            
            Text("Wellcome to Did I Floss")
                .font(.largeTitle)
                .monospaced()
                .padding()
            
            VStack(spacing: 30) {
                createRowView(feature: OnboardingRowInfoModel.WellcomeFeatures.calendar)
                
                createRowView(feature: OnboardingRowInfoModel.WellcomeFeatures.streak)
                
                createRowView(feature: OnboardingRowInfoModel.WellcomeFeatures.notifications)
                
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
    
    
    func createRowView(feature: OnboardingRowInfoModel) -> some View {
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
