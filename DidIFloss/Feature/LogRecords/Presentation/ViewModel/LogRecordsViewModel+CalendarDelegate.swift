//
//  LogRecordsViewModel+CalendarDelegate.swift
//  DidIFloss
//
//  Created by Lucas Migge on 02/02/24.
//

import Foundation
import SwiftUI

extension LogRecordsViewModel: CalendarViewDelegate {
    func didSelectDate(_ date: Date) {
        withAnimation {
            selectedDate = selectedDate == date ? nil : date
        }
    }
}
