//
//  HomeViewModel+PersistenceDelegate.swift
//  DidIFloss
//
//  Created by Lucas Migge on 02/02/24.
//

import Foundation

extension HomeViewModel: PersistenceDelegate {
    func hadChangesInFlossRecordDataBase() {
        self.loadData()
    }
}
