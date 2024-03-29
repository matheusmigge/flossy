//
//  OnboardingView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 01/02/24.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.colorScheme) var colorScheme
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
            
            VStack(alignment: .leading, spacing: 20) {
                
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
                    .foregroundStyle(colorScheme == .light ? .white : .black)
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom)
            
            
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
                    .scaledToFill()
                    .frame(width: 35, height: 35)
                    .foregroundStyle(Color.accentColor)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(feature.title)
                        .font(.headline)
                    
                    Text(feature.message)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    
                }
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    OnboardingView()
}
