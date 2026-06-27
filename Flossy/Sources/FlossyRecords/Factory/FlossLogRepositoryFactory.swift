//
//  FlossRercordRepositoryFactory.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 25/06/26.
//


public protocol FlossRecordRepositoryFactory {
    static func make() -> any FlossLogRepository
}

public enum DefaultFlossLogRepositoryFactory: FlossRecordRepositoryFactory {
    public static func make() -> any FlossLogRepository {
        let dataSource = SwiftDataFlossRecordDataSource.shared
        return DefaultFlossLogRepository(dataSource: dataSource)
    }
}
