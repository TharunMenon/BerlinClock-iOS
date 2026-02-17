//
//  BerlinTimeTests.swift
//  BerlinClock
//
//  Created by Tharun Menon on 17/02/26.
//

import XCTest
@testable import BerlinClock

final class BerlinTimeTests: XCTestCase {

   func testTimeCreation() {
        //Given
       let time = BerlinTime(hours: 14, minutes: 30, seconds: 45)
       
       //Then
       XCTAssertEqual(time.hours, 14)
       XCTAssertEqual(time.minutes, 30)
       XCTAssertEqual(time.seconds, 45)
    }
    
    func testTimeBoundaryValidation() {
        //Given & when
        let invalidTime = BerlinTime(hours: 25, minutes: 70, seconds: 70)
        
        //Then
        XCTAssertEqual(invalidTime.hours, 23)
        XCTAssertEqual(invalidTime.minutes, 59)
        XCTAssertEqual(invalidTime.seconds, 59)
    }
    
    func testTimeEquality() {
        let time1 = BerlinTime(hours: 10, minutes: 20, seconds: 30)
        let time2 = BerlinTime(hours: 10, minutes: 20, seconds: 30)
        let time3 = BerlinTime(hours: 10, minutes: 20, seconds: 31)
        //Then
        XCTAssertEqual(time1, time2)
        XCTAssertNotEqual(time1, time3)
    }
}
