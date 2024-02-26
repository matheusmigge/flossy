//
//  StreakBoardView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 01/02/24.
//

import SwiftUI

struct StreakBoardView: View {
    
    let model: StreakBoardModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ZStack {
                    Text(model.titleText)
                        .font(.system(size: 35))
                        .fontWeight(.black)
                        .offset(x: -1, y: 1)
                        .foregroundStyle(Color.primary)
                    
                    Text(model.titleText)
                        .font(.system(size: 35))
                        .fontWeight(.black)
                        .foregroundStyle(model.titleColor)
                }
                Spacer()
            }
            .foregroundStyle(Color("sky-blue"))
            
            Text(model.captionText)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    StreakBoardView(model: StreakBoardModel(titleColor: .greenyBlue, titleText: "Combo iniciado!", captionText: "Continue passando o fio dental todos os dias para manter o seu combo."))
}
