//
//  BannerSectionView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 24/01/24.
//

import SwiftUI

struct BannerSectionView: View {
    var body: some View {
        
        Section {
            VStack {
                HStack {
                    ToothView(style: .pink, size: 70)
                    Spacer()
                    ToothView(style: .yellow, size: 70)
                    Spacer()
                    ToothView(style: .pink, size: 70)
                }
                
                
                HStack {
                    Spacer()
                    ToothView(style: .yellow, size: 70)
                    Spacer()
                    ToothView(style: .pink, size: 70)
                    Spacer()
                }
            }
            .background(Color("sky-blue"))
        }.listRowInsets(.init(top: -20, leading: -20, bottom: -20, trailing: -20))
    }
}

#Preview {
    BannerSectionView()
}
