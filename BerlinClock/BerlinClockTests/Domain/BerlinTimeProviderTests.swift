//
//  BerlinTimeProviderTests.swift
//  BerlinClockTests
//
//  Created by Tharun Menon on 17/02/26.
//

import XCTest

final class BerlinTimeProviderTests: XCTestCase {

    private var timeProvider: BerlinTimeProvider!
        
        override func setUp() {
            super.setUp()
            timeProvider = SystemTimeProvider() 
        }
        
        override func tearDown() {
            timeProvider = nil
            super.tearDown()
        }
        
        func testGetCurrentTime_ReturnsValidTime() {
            // When
            let time = timeProvider.getCurrentTime()
            
            // Then
            XCTAssertGreaterThanOrEqual(time.hours, 0)
            XCTAssertLessThanOrEqual(time.hours, 23)
            XCTAssertGreaterThanOrEqual(time.minutes, 0)
            XCTAssertLessThanOrEqual(time.minutes, 59)
            XCTAssertGreaterThanOrEqual(time.seconds, 0)
            XCTAssertLessThanOrEqual(time.seconds, 59)
        }
        
        func testGetCurrentTime_CalledMultipleTimes_ReturnsReasonableValues() {
            // When
            let time1 = timeProvider.getCurrentTime()
            let time2 = timeProvider.getCurrentTime()
            
            // Then - Times should be very close (within a second)
            let timeDifference = abs(time2.seconds - time1.seconds)
            XCTAssertLessThanOrEqual(timeDifference, 1, "Time difference should be minimal")
        }
     

}
