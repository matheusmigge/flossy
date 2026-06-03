//
//  BackgroundView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 03/01/24.
//

import SwiftUI

struct BackgroundView: View {
    
    private static let size: CGFloat = 140
    private static let spacingBetweenColumns: CGFloat = 50
    private static let spacingBetweenRows: CGFloat = 50
    private static let totalColumns: Int = 5
    private static let totalElements: Int = 40
    
    let gridItems: [GridItem] = Array(
        repeating: GridItem(
            .fixed(size),
            spacing: spacingBetweenColumns,
            alignment: .center
        ), count: totalColumns
    )
    
    var body: some View {
        
        ZStack {
            
            Color.accentColorAlternative
            
            LazyVGrid(
                columns: gridItems,
                alignment: .center,
                spacing: BackgroundView.spacingBetweenRows) {
                    ForEach(0..<BackgroundView.totalElements, id: \.self) { elementNumber in
                        
                        ToothView(style: toothColor(elementNumber), size: BackgroundView.size)
                            .offset(x: offsetX(elementNumber))
                    }
            }
        }
    }
    
    func offsetX(_ elementNumber: Int) -> CGFloat {
        let rowNumber = elementNumber / BackgroundView.totalColumns
        
        if rowNumber % 2 == 0 {
            return BackgroundView.size / 2 + BackgroundView.spacingBetweenColumns / 2
        }
        
        return 0 
    }
    
    func toothColor(_ number: Int) -> ToothView.Style {
        if number % 2 == 0 {
            return ToothView.Style.pink
        }
        
        return ToothView.Style.yellow
    }
}

#Preview {
    BackgroundView()
}
