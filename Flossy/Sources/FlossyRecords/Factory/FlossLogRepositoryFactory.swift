//
//  FlossRercordRepositoryFactory.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 25/06/26.
//


public enum FlossLogRepositoryFactory {
    public static func make() -> any FlossLogRepository {
        let dataSource = SwiftDataFlossRecordDataSource.shared
        return DefaultFlossLogRepository(dataSource: dataSource)
    }
}
