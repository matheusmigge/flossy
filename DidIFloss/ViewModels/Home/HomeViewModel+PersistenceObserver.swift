//
//  HomeViewModel+PersistenceObserver.swift
//  DidIFloss
//
//  Created by Lucas Migge on 02/02/24.
//

import Foundation

extension HomeViewModel: PersistenceObserver {
    func hadChangesInFlossRecordDataBase() {
        self.loadData()
    }
}
