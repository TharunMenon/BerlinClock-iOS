//
//  BerlinClockViewTests.swift
//  BerlinClockTests
//
//  Created by Tharun Menon on 18/02/26.
//

import XCTest
import SwiftUI
@testable import BerlinClock

final class BerlinClockViewTests: XCTestCase {

    private var viewModel: BerlinClockViewModel!
        private var mockTimeProvider: MockBerlinTimeProvider!
        private var converter: BerlinClockConverter!
        
    @MainActor
    override func setUp() {
            super.setUp()
            mockTimeProvider = MockBerlinTimeProvider(fixedTime: BerlinTime(hours: 14, minutes: 30, seconds: 24)) // Even seconds
            converter = DefaultBerlinClockConverter()
            viewModel = BerlinClockViewModel(timeProvider: mockTimeProvider, converter: converter)
            viewModel.updateTime()
    }
        
    override func tearDown() {
            viewModel = nil
            converter = nil
            mockTimeProvider = nil
            super.tearDown()
    }
        
    @MainActor
    func testBerlinClockViewExists() throws {
            // This test will fail until we implement BerlinClockView
            // Given & When
            let view = BerlinClockView(viewModel: viewModel)
            
            // Then - View should be creatable
            XCTAssertNotNil(view)
    }
        
    @MainActor
    func testViewModelDataBinding() throws {
            // This test verifies the view model is properly connected
            // Given - Even seconds (24), should be lit
            XCTAssertTrue(viewModel.secondsLamp)
            XCTAssertEqual(viewModel.fiveHoursRow, [true, true, false, false])
            XCTAssertEqual(viewModel.singleHoursRow, [true, true, true, true])
            
            // 30 minutes = 6 blocks of 5
            let expectedFiveMinutes = [true, true, true, true, true, true, false, false, false, false, false]
            XCTAssertEqual(viewModel.fiveMinutesRow, expectedFiveMinutes)
            XCTAssertEqual(viewModel.singleMinutesRow, [false, false, false, false])
    }
        
    @MainActor
    func testViewModelTimerIntegration() throws {
            // This test verifies timer functionality for UI integration
            // Given
            XCTAssertFalse(viewModel.isTimerRunning)
            
            // When
            viewModel.startTimer()
            
            // Then
            XCTAssertTrue(viewModel.isTimerRunning)
            
            // When
            viewModel.stopTimer()
            
            // Then
            XCTAssertFalse(viewModel.isTimerRunning)
        }
     
}
