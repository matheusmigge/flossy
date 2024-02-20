//
//  OnboardingView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 01/02/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 50){
            
            HStack(spacing: -22) {
                Text("Wellcome to")
                    .bold()
                    .font(.system(size: 30))
                    .padding(.horizontal)
                
                Text("Flossy")
                    .font(.custom(Constants.FontNames.borel, size: 30))
                    .padding(.horizontal)
                    .padding(.bottom, -24)
            }
            .padding(.vertical, 20)
            
            VStack(alignment: .leading, spacing: 30) {
                
                createRowView(feature: OnboardingRowInfoModel.WellcomeFeatures.calendar)
                
                createRowView(feature: OnboardingRowInfoModel.WellcomeFeatures.streak)
                
                createRowView(feature: OnboardingRowInfoModel.WellcomeFeatures.notifications)
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Continue")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 70)
            
            
        }
        .padding(25)
        .presentationBackgroundInteraction(.enabled)
        .presentationCornerRadius(25)
        .presentationBackground(Material.regular)
    }
    
    
    func createRowView(feature: OnboardingRowInfoModel) -> some View {
        VStack {
            HStack {
                Image(systemName: feature.iconString)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
                    .foregroundStyle(Color.accentColor)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(feature.title)
                        .font(.headline)
                    
                    Text(feature.message)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    
                }
                .multilineTextAlignment(.leading)
                .padding(.leading)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    OnboardingView()
}
