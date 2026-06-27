//
//  FlossLogRepositoryFactoryTests.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 26/06/26.
//

import Testing
@testable import FlossyRecords

struct FlossLogRepositoryFactoryTests {

    @Test
    func testMakeShouldReturnDefaultImplementationForFlossRepository() {
        let repository = DefaultFlossLogRepositoryFactory.make()
        #expect(repository is DefaultFlossLogRepository)
    }
}
