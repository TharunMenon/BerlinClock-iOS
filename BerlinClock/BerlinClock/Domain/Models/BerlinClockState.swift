//
//  BerlinClockState.swift
//  BerlinClock
//
//  Created by Tharun Menon on 17/02/26.
//

import Foundation

public struct BerlinClockState:Equatable {
    //Seconds-light
    let secondsLamp:Bool
    
    //5Hour-row
    let fiveHoursRow:[Bool]
    
    //SingleHour-Row
    let singleHoursRow:[Bool]
    
    //5Minutes-Row
    let fiveMinutesRow:[Bool]
    
    //SingleMinutes-Row
    let singleMinutesRow:[Bool]
    
    public init(secondsLamp: Bool = false, fiveHoursRow: [Bool] = Array(repeating:false,count: 4), singleHoursRow: [Bool] = Array(repeating:false,count: 4), fiveMinutesRow: [Bool] = Array(repeating:false,count: 11), singleMinutesRow: [Bool] = Array(repeating:false,count: 4)) {
        self.secondsLamp = secondsLamp
        self.fiveHoursRow = fiveHoursRow
        self.singleHoursRow = singleHoursRow
        self.fiveMinutesRow = fiveMinutesRow
        self.singleMinutesRow = singleMinutesRow
    }
}
