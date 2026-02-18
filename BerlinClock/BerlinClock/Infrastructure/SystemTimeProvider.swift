//
//  SystemTimeProvider.swift
//  BerlinClock
//
//  Created by Tharun Menon on 17/02/26.
//

import Foundation

public final class SystemTimeProvider: BerlinTimeProvider {
    
    public init() {}
    
    // Gets the current system time
    public func getCurrentTime() -> BerlinTime {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: now)
        
        return BerlinTime(
            hours: components.hour ?? 0,
            minutes: components.minute ?? 0,
            seconds: components.second ?? 0
        )
    }
}
