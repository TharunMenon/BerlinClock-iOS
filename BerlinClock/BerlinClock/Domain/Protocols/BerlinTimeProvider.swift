//
//  BerlinTimeProvider.swift
//  BerlinClock
//
//  Created by Tharun Menon on 17/02/26.
//

import Foundation

//To get current time
public protocol BerlinTimeProvider {
    func getCurrentTime() -> BerlinTime
}
