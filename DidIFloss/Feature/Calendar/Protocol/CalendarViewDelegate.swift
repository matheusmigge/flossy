//
//  CalendarViewDelegate.swift
//  DidIFloss
//
//  Created by Lucas Migge on 22/01/24.
//

import Foundation

protocol CalendarViewDelegate: AnyObject {
    func didSelectDate(_ date: Date)
    
}
