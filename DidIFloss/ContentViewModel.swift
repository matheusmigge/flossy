//
//  ContentViewModel.swift
//  DidIFloss
//
//  Created by Matheus Migge on 27/12/23.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    // MARK: Published variables
    
    @Published private var lastFloss: Date?
    @Published private var flossCount: Int?
    
    // MARK: Init
    
    init(lastFloss: Date? = nil, flossCount: Int? = nil) {
        self.lastFloss = lastFloss
        self.flossCount = flossCount
    }
    
    // MARK: Public variables and methods
    
    var formatedLastFloss: String {
        
        guard let safeDate = lastFloss else {
            return "You haven't flossed yet!"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: safeDate)
        
        //        if let safeDate = lastFloss {
        //            let dateFormatter = DateFormatter()
        //            dateFormatter.dateStyle = .medium
        //            dateFormatter.timeStyle = .short
        //
        //            return dateFormatter.string(from: safeDate)
        //        }
        //
        //        return "You haven't flossed yet!"
    }
    
    var formatedFlossCount: String {
        
        guard let safeFlossCount = flossCount else {
            return "You haven't flossed yet!"
        }
        
        return "\(safeFlossCount)"
        
        //        if let safeFlossCount = flossCount {
        //            return "\(safeFlossCount)"
        //        }
    }
    
    func flossButtonPressed() {
        
        self.lastFloss = Date()
        
        if let safeFlossCount = flossCount {
            self.flossCount = safeFlossCount + 1
        } else {
            self.flossCount = 1
        }
    }
}
