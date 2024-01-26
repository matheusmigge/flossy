//
//  Date.swift
//  DidIFloss
//
//  Created by Lucas Migge on 16/01/24.
//

import Foundation

extension Date {
    var monthFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        return formatter.string(from: self)
    }
    
    var dayFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        return formatter.string(from: self)
    }
    
    var dayAndMonthFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        
        return formatter.string(from: self)
    }
}