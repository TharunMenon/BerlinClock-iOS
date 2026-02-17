//
//  BerlinTime.swift
//  BerlinClock
//
//  Created by Tharun Menon on 17/02/26.
//

import Foundation

public struct BerlinTime:Equatable{
    let hours:Int
    let minutes:Int
    let seconds:Int
    
    public init(hours:Int,minutes:Int,seconds:Int){
        self.hours = max(0, min(23,hours))
        self.minutes = max(0, min(59,minutes))
        self.seconds = max(0, min(59,seconds))
    }
    
  
}
