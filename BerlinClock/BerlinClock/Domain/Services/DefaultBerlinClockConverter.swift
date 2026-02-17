//
//  DefaultBerlinClockConverter.swift
//  BerlinClock
//
//  Created by Tharun Menon on 17/02/26.
//

import Foundation

public class DefaultBerlinClockConverter: BerlinClockConverter {
    
    public init() {}
    
    public func convert(_time time: BerlinTime) -> BerlinClockState {
        return BerlinClockState(
            secondsLamp: convertSecondsLamp(time.seconds),
            fiveHoursRow: convertFiveHoursRow(time.hours),
            singleHoursRow: convertSingleHoursRow(time.hours),
            fiveMinutesRow: convertFiveMinutesRow(time.minutes),
            singleMinutesRow: convertSingleMinutesRow(time.minutes)
        )
    }
    
    // MARK: - Private Conversion Methods
    
    private func convertSecondsLamp(_ seconds: Int) -> Bool {
        return seconds % 2 == 0
    }
    
    private func convertFiveHoursRow(_ hours: Int) -> [Bool] {
        let numberOfLights = hours / 5
        return createRowWithLights(totalLights: 4, lightsOn: numberOfLights)
    }
    
    private func convertSingleHoursRow(_ hours: Int) -> [Bool] {
        let numberOfLights = hours % 5
        return createRowWithLights(totalLights: 4, lightsOn: numberOfLights)
    }
    
    private func convertFiveMinutesRow(_ minutes: Int) -> [Bool] {
        let numberOfLights = minutes / 5
        return createRowWithLights(totalLights: 11, lightsOn: numberOfLights)
    }
    
    private func convertSingleMinutesRow(_ minutes: Int) -> [Bool] {
        let numberOfLights = minutes % 5
        return createRowWithLights(totalLights: 4, lightsOn: numberOfLights)
    }
    
    private func createRowWithLights(totalLights: Int, lightsOn: Int) -> [Bool] {
        var row = Array(repeating: false, count: totalLights)
        for i in 0..<min(lightsOn, totalLights) {
            row[i] = true
        }
        return row
    }
}
 
