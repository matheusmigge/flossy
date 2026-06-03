//
//  WarningBannerView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 27/01/24.
//

import SwiftUI

struct WarningBannerView: View {
    
    let model: WarningBannerModel
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .foregroundStyle(model.backgroundColor)
            
            Text(model.text)
                .padding(20)
                .foregroundStyle(model.textColor)
                .font(.caption)
                .bold()

        }
        .listRowInsets(.init(top: -10, leading: -10, bottom: -10, trailing: -10))
    }
}

#Preview {
    WarningBannerView(model: WarningBannerModel(backgroundColor: .greenyBlue, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. 🙌", textColor: .white))
}
