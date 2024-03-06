//
//  HapticsManagerTests.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 29/02/24.
//

import XCTest
@testable import DidIFloss

final class HapticsManagerTests: XCTestCase {
    
    var feedbackGenerator: UINotificationFeedbackGeneratorMock!
    var hapticsManager: HapticsManager!

    override func setUpWithError() throws {
        
        self.feedbackGenerator = UINotificationFeedbackGeneratorMock()
        self.hapticsManager = HapticsManager(feedbackGenerator: feedbackGenerator)
        
    }

    func testVibrateCelebrationCallsGeneratorWithCorrespondingStyle() {
        let feedbackOption: HapticFeedbackOption = .medium
        feedbackGenerator.lastVibrationStyleTriggered = nil
        hapticsManager.preferredCelebrationFeedbackType = feedbackOption
  
        
        hapticsManager.vibrateAddLogCelebration()
        
        
        XCTAssertEqual(feedbackOption.feedBackStyle, feedbackGenerator.lastVibrationStyleTriggered)
        XCTAssertTrue(feedbackGenerator.didVibrate)
    }
  
    
    func testVibrateCelebrationDontCallsGeneratorWithStyleIsNone() {
        let feedbackOption: HapticFeedbackOption = .none
        feedbackGenerator.lastVibrationStyleTriggered = nil
        hapticsManager.preferredCelebrationFeedbackType = feedbackOption
  
        
        hapticsManager.vibrateAddLogCelebration()
        
        
        XCTAssertNil(feedbackGenerator.lastVibrationStyleTriggered)
        XCTAssertFalse(feedbackGenerator.didVibrate)
    }
    
    
    func testVibrateLogRemovalCallsGeneratorWithCorrespondingStyle() {
        
        let feedbackOption: HapticFeedbackOption = .long
        feedbackGenerator.lastVibrationStyleTriggered = nil
        hapticsManager.preferredDeletionFeedbackType = feedbackOption
  
        
        hapticsManager.vibrateLogRemoval()
        
        
        XCTAssertEqual(feedbackOption.feedBackStyle, feedbackGenerator.lastVibrationStyleTriggered)
        XCTAssertTrue(feedbackGenerator.didVibrate)
    }
  
    
    func testVibrateLogRemovalDontCallsGeneratorWithStyleIsNone() {
        
        let feedbackOption: HapticFeedbackOption = .none
        feedbackGenerator.lastVibrationStyleTriggered = nil
        hapticsManager.preferredDeletionFeedbackType = feedbackOption
  
        
        hapticsManager.vibrateLogRemoval()
        
        XCTAssertNil(feedbackGenerator.lastVibrationStyleTriggered)
        XCTAssertFalse(feedbackGenerator.didVibrate)
    }

}
