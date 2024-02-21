//
//  HomeViewModel+CelebrationDelegate.swift
//  DidIFloss
//
//  Created by Lucas Migge on 02/02/24.
//

import Foundation
import SwiftUI


extension HomeViewModel: CelebrationDelegate {
    func didCompleteAnimation() {
        showingCelebration = false
    }
}
