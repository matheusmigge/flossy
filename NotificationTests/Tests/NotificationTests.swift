//
//  NotificationTests.swift
//  NotificationTests
//
//  Created by Lucas Migge on 29/01/24.
//

import XCTest
@testable import Notification

final class NotificationTests: XCTestCase {
    
    var service: NotificationService?
    
    override func setUpWithError() throws {
        self.service = NotificationService(center: UNUserNoticationCenterMock())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

    }

    func testExample() throws {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
