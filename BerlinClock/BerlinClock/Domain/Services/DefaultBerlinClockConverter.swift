//
//  DefaultBerlinClockConverter.swift
//  BerlinClock
//
//  Created by Tharun Menon on 17/02/26.
//

import Foundation

public class DefaultBerlinClockConverter: BerlinClockConverter {
    
    // MARK: - Constants
    private static let fiveHourRowSize = 4
    private static let singleHourRowSize = 4
    private static let fiveMinuteRowSize = 11
    private static let singleMinuteRowSize = 4
    
    
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
    // Converts seconds to seconds lamp 
    private func convertSecondsLamp(_ seconds: Int) -> Bool {
        return seconds % 2 == 0
    }
    // Converts hours to five-hour row
    private func convertFiveHoursRow(_ hours: Int) -> [Bool] {
        let numberOfActiveLights = hours / 5
        return createRowWithActiveLights(totalLights: Self.fiveHourRowSize,activeLights: numberOfActiveLights)
    }
    // Converts hours to Singlr hour row
    private func convertSingleHoursRow(_ hours: Int) -> [Bool] {
        let numberOfActiveLights = hours % 5
        return createRowWithActiveLights(totalLights: Self.singleHourRowSize,activeLights: numberOfActiveLights)
    }
    // Converts minutes to five-minute row
    private func convertFiveMinutesRow(_ minutes: Int) -> [Bool] {
        let numberOfActiveLights = minutes / 5
         return createRowWithActiveLights(totalLights: Self.fiveMinuteRowSize,activeLights: numberOfActiveLights)
    }
    // Converts minutes to single-minute row
    private func convertSingleMinutesRow(_ minutes: Int) -> [Bool] {
        let numberOfActiveLights = minutes % 5
        return createRowWithActiveLights(totalLights: Self.singleMinuteRowSize,activeLights: numberOfActiveLights)
    }
    // Creates a row array with specified number of active lights
    private func createRowWithActiveLights(totalLights: Int, activeLights: Int) -> [Bool] {
        var lightRow = Array(repeating: false, count: totalLights)
        let safeLightCount = min(activeLights, totalLights)
        for lightIndex in 0..<safeLightCount {
            lightRow[lightIndex] = true}
        return lightRow
    }
    
}
 
