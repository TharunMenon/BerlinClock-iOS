//
//  BerlinClockViewModelTests.swift
//  BerlinClockTests
//
//  Created by Tharun Menon on 18/02/26.
//

import XCTest
import Combine
@testable import BerlinClock

final class BerlinClockViewModelTests: XCTestCase {
    private var viewModel: BerlinClockViewModel!
    private var mockTimeProvider: MockBerlinTimeProvider!
    private var converter: BerlinClockConverter!
    private var cancellables: Set<AnyCancellable>!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockTimeProvider = MockBerlinTimeProvider(fixedTime: BerlinTime(hours: 14, minutes: 30, seconds: 25))
        converter = DefaultBerlinClockConverter()
        viewModel = BerlinClockViewModel(timeProvider: mockTimeProvider, converter: converter)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        converter = nil
        mockTimeProvider = nil
        super.tearDown()
    }
    
    @MainActor
    func testInitialState() {
        // Then
        XCTAssertFalse(viewModel.secondsLamp)
        XCTAssertEqual(viewModel.fiveHoursRow, [false, false, false, false])
        XCTAssertEqual(viewModel.singleHoursRow, [false, false, false, false])
        XCTAssertEqual(viewModel.fiveMinutesRow, Array(repeating: false, count: 11))
        XCTAssertEqual(viewModel.singleMinutesRow, [false, false, false, false])
    }
    
    @MainActor
    func testUpdateTime() {
        // When
        viewModel.updateTime()
        
        // Then - Based on mock time 14:30:25
        XCTAssertFalse(viewModel.secondsLamp) // 25 is odd
        XCTAssertEqual(viewModel.fiveHoursRow, [true, true, false, false]) // 14 = 2*5 + 4
        XCTAssertEqual(viewModel.singleHoursRow, [true, true, true, true]) // 4 hours
        
        // 30 minutes = 6*5 + 0
        let expectedFiveMinutes = [true, true, true, true, true, true, false, false, false, false, false]
        XCTAssertEqual(viewModel.fiveMinutesRow, expectedFiveMinutes)
        XCTAssertEqual(viewModel.singleMinutesRow, [false, false, false, false]) // 0 minutes
    }
    
    @MainActor
    func testStartStopTimer() {
        // Given
        let expectation = XCTestExpectation(description: "Timer should update")
        
        viewModel.$secondsLamp
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        viewModel.startTimer()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        
        // When
        viewModel.stopTimer()
        
        
    }
}
