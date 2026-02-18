//
//  BerlinClockConverterIntegrationTests.swift
//  BerlinClockTests
//
//  Created by Tharun Menon on 18/02/26.
//

import XCTest

final class BerlinClockConverterIntegrationTests: XCTestCase {

        private var converter: BerlinClockConverter!
        private var mockTimeProvider: MockBerlinTimeProvider!
        
        override func setUp() {
            super.setUp()
            converter = DefaultBerlinClockConverter()
        }
        
        override func tearDown() {
            mockTimeProvider = nil
            converter = nil
            super.tearDown()
        }
        
        func testTimeProviderAndConverter_Integration() {
            // Given
            let fixedTime = BerlinTime(hours: 12, minutes: 15, seconds: 30)
            mockTimeProvider = MockBerlinTimeProvider(fixedTime: fixedTime)
            
            // When
            let currentTime = mockTimeProvider.getCurrentTime()
            let clockState = converter.convert(_time: currentTime)
            
            // Then
            XCTAssertEqual(currentTime, fixedTime)
            XCTAssertTrue(clockState.secondsLamp) // 30 is even
            XCTAssertEqual(clockState.fiveHoursRow, [true, true, false, false]) // 12 = 2*5 + 2
            XCTAssertEqual(clockState.singleHoursRow, [true, true, false, false]) // 2 hours
            
            // 15 minutes = 3*5 + 0
            var expectedFiveMinutes = Array(repeating: false, count: 11)
            for i in 0..<3 { expectedFiveMinutes[i] = true }
            XCTAssertEqual(clockState.fiveMinutesRow, expectedFiveMinutes)
            XCTAssertEqual(clockState.singleMinutesRow, [false, false, false, false]) // 0 minutes
        }
        
        func testMockTimeProvider_ConsistentTime() {
            // Given
            let fixedTime = BerlinTime(hours: 23, minutes: 59, seconds: 59)
            mockTimeProvider = MockBerlinTimeProvider(fixedTime: fixedTime)
            
            // When
            let time1 = mockTimeProvider.getCurrentTime()
            let time2 = mockTimeProvider.getCurrentTime()
            
            // Then
            XCTAssertEqual(time1, time2)
            XCTAssertEqual(time1, fixedTime)
        }
    }

