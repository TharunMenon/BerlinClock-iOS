//
//  BerlinClockConverter.swift
//  BerlinClock
//
//  Created by Tharun Menon on 17/02/26.
//

import Foundation

public protocol BerlinClockConverter {
    //convert time to berlinclockstate
    func convert(_time:BerlinTime) -> BerlinClockState
}
