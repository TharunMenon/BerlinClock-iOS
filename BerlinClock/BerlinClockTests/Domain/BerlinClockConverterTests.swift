//
//  BerlinClockConverterTests.swift
//  BerlinClockTests
//
//  Created by Tharun Menon on 17/02/26.
//

import XCTest
@testable import BerlinClock

final class BerlinClockConverterTests: XCTestCase {

    private var converter: BerlinClockConverter!
    
    override func setUp() {
        super.setUp()
        converter = DefaultBerlinClockConverter()
    }
    
    override func tearDown() {
        converter = nil
        super.tearDown()
    }
        
    //MARK:- Second lamp tests
    func testsSecondLamp() {
        //Given
        let time = BerlinTime(hours: 0, minutes: 0, seconds: 0)
        
        //When
        let state = converter.convert(_time: time)
        
        //Then
        XCTAssertTrue(state.secondsLamp, "Seconds lamp should be ON for even seconds")

    }
        
    func testSecondsLamp_OddSeconds_ShouldBeOff() {
            // Given
            let time = BerlinTime(hours: 0, minutes: 0, seconds: 1)
            
            // When
        let state = converter.convert(_time: time)
            
            // Then
            XCTAssertFalse(state.secondsLamp, "Seconds lamp should be OFF for odd seconds")
        }
        
        // MARK: - Five Hours Row Tests
    func testFiveHoursRow_Midnight_AllOff() {
            // Given
            let time = BerlinTime(hours: 0, minutes: 0, seconds: 0)
            
            // When
            let state = converter.convert(_time: time)
            
            // Then
            XCTAssertEqual(state.fiveHoursRow, [false, false, false, false])
        }
        
    func testFiveHoursRow_5AM_OneLightOn() {
            // Given
            let time = BerlinTime(hours: 5, minutes: 0, seconds: 0)
            
            // When
            let state = converter.convert(_time: time)
            
            // Then
            XCTAssertEqual(state.fiveHoursRow, [true, false, false, false])
        }
        
    func testFiveHoursRow_13PM_TwoLightsOn() {
            // Given
            let time = BerlinTime(hours: 13, minutes: 0, seconds: 0)
            
            // When
            let state = converter.convert(_time: time)
            
            // Then
            XCTAssertEqual(state.fiveHoursRow, [true, true, false, false])
        }
        
    func testFiveHoursRow_23PM_FourLightsOn() {
            // Given
            let time = BerlinTime(hours: 23, minutes: 0, seconds: 0)
            
            // When
            let state = converter.convert(_time: time)
            
            // Then
            XCTAssertEqual(state.fiveHoursRow, [true, true, true, true])
        }
        
        // MARK: - Single Hours Row Tests
    func testSingleHoursRow_Midnight_AllOff() {
            // Given
            let time = BerlinTime(hours: 0, minutes: 0, seconds: 0)
            
            // When
            let state = converter.convert(_time: time)
            
            // Then
            XCTAssertEqual(state.singleHoursRow, [false, false, false, false])
        }
        
    func testSingleHoursRow_1AM_OneLightOn() {
            // Given
            let time = BerlinTime(hours: 1, minutes: 0, seconds: 0)
            
            // When
            let state = converter.convert(_time: time)
            
            // Then
            XCTAssertEqual(state.singleHoursRow, [true, false, false, false])
        }
        
    func testSingleHoursRow_14PM_FourLightsOn() {
            // Given: 14 so 4 single hour lights should be on
            let time = BerlinTime(hours: 14, minutes: 0, seconds: 0)
            
            // When
            let state = converter.convert(_time: time)
            
            // Then
            XCTAssertEqual(state.singleHoursRow, [true, true, true, true])
        }
        
        // MARK: - Five Minutes Row Tests
    func testFiveMinutesRow_ZeroMinutes_AllOff() {
            // Given
            let time = BerlinTime(hours: 0, minutes: 0, seconds: 0)
            
            // When
            let state = converter.convert(_time: time)
            
            // Then
            let expectedRow = Array(repeating: false, count: 11)
            XCTAssertEqual(state.fiveMinutesRow, expectedRow)
        }
        
    func testFiveMinutesRow_5Minutes_OneLightOn() {
            // Given
            let time = BerlinTime(hours: 0, minutes: 5, seconds: 0)
            
            // When
            let state = converter.convert(_time: time)
            
            // Then
            var expectedRow = Array(repeating: false, count: 11)
            expectedRow[0] = true
            XCTAssertEqual(state.fiveMinutesRow, expectedRow)
        }
        
    func testFiveMinutesRow_55Minutes_AllLightsOn() {
            // Given
            let time = BerlinTime(hours: 0, minutes: 55, seconds: 0)
            
            // When
            let state = converter.convert(_time: time)
            
            // Then
            let expectedRow = Array(repeating: true, count: 11)
            XCTAssertEqual(state.fiveMinutesRow, expectedRow)
        }
        
        // MARK: - Single Minutes Row Tests
    func testSingleMinutesRow_ZeroMinutes_AllOff() {
            // Given
            let time = BerlinTime(hours: 0, minutes: 0, seconds: 0)
            
            // When
            let state = converter.convert(_time: time)
            
            // Then
            XCTAssertEqual(state.singleMinutesRow, [false, false, false, false])
        }
        
    func testSingleMinutesRow_1Minute_OneLightOn() {
            // Given
            let time = BerlinTime(hours: 0, minutes: 1, seconds: 0)
            
            // When
            let state = converter.convert(_time: time)
            
            // Then
            XCTAssertEqual(state.singleMinutesRow, [true, false, false, false])
        }
        
    func testSingleMinutesRow_59Minutes_FourLightsOn() {
            // Given: 59 =  4 single minute lights should be on
            let time = BerlinTime(hours: 0, minutes: 59, seconds: 0)
            
            // When
            let state = converter.convert(_time: time)
            
            // Then
            XCTAssertEqual(state.singleMinutesRow, [true, true, true, true])
        }
        
        // MARK: - Integration Tests
    func testCompleteTime_14h30m25s() {
            // Given: 14:30:25
            let time = BerlinTime(hours: 14, minutes: 30, seconds: 25)
            
            // When
            let state = converter.convert(_time: time)
            
            // Then
            XCTAssertFalse(state.secondsLamp) // 25 is odd
            XCTAssertEqual(state.fiveHoursRow, [true, true, false, false]) // 14 = 2*5 + 4
            XCTAssertEqual(state.singleHoursRow, [true, true, true, true]) // 4 hours
            
            // 30 minutes = 6*5 + 0
            var expectedFiveMinutes = Array(repeating: false, count: 11)
            for i in 0..<6 { expectedFiveMinutes[i] = true }
            XCTAssertEqual(state.fiveMinutesRow, expectedFiveMinutes)
            XCTAssertEqual(state.singleMinutesRow, [false, false, false, false]) // 0 minutes
        }

}
