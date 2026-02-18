//
//  BerlinClockViewModel.swift
//  BerlinClock
//
//  Created by Tharun Menon on 18/02/26.
//

import Foundation
import Combine

@MainActor
public final class BerlinClockViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published public private(set) var secondsLamp: Bool = false
    @Published public private(set) var fiveHoursRow: [Bool] = Array(repeating: false, count: 4)
    @Published public private(set) var singleHoursRow: [Bool] = Array(repeating: false, count: 4)
    @Published public private(set) var fiveMinutesRow: [Bool] = Array(repeating: false, count: 11)
    @Published public private(set) var singleMinutesRow: [Bool] = Array(repeating: false, count: 4)
    
    // MARK: - Dependencies
    private let timeProvider: BerlinTimeProvider
    private let converter: BerlinClockConverter
    
    // MARK: - Timer
    private var timer: Timer?
    
    public var isTimerRunning: Bool {
        return timer != nil
    }
    
    // MARK: - Initialization
    public init(timeProvider: BerlinTimeProvider, converter: BerlinClockConverter) {
        self.timeProvider = timeProvider
        self.converter = converter
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Public Methods
    
    // Updates the clock with current time
    public func updateTime() {
        let currentTime = timeProvider.getCurrentTime()
        let clockState = converter.convert(_time: currentTime)
        
        secondsLamp = clockState.secondsLamp
        fiveHoursRow = clockState.fiveHoursRow
        singleHoursRow = clockState.singleHoursRow
        fiveMinutesRow = clockState.fiveMinutesRow
        singleMinutesRow = clockState.singleMinutesRow
    }
    
    // Starts the timer to update every second
    public func startTimer() {
        stopTimer()
        updateTime()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor [weak self] in
                self?.updateTime()
            }
        }
    }
    
    // Stops the timer
    public func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
