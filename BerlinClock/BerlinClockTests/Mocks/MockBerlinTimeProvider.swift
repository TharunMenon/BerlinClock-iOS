//
//  MockBerlinTimeProvider.swift
//  BerlinClockTests
//
//  Created by Tharun Menon on 18/02/26.
//

import XCTest
import Foundation
@testable import BerlinClock

final class MockBerlinTimeProvider: BerlinTimeProvider {

    private let fixedTime: BerlinTime
        
        init(fixedTime: BerlinTime) {
            self.fixedTime = fixedTime
        }
        
        func getCurrentTime() -> BerlinTime {
            return fixedTime
        }
     

}
