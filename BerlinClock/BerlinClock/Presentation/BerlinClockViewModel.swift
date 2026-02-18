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
    
    
    // MARK: - Constants
        private static let timerInterval: TimeInterval = 1.0
        private static let defaultRowSizes = (
            fiveHours: 4,
            singleHours: 4,
            fiveMinutes: 11,
            singleMinutes: 4
        )
    
    
    // MARK: - Published Properties
    @Published public private(set) var secondsLamp: Bool = false
    @Published public private(set) var fiveHoursRow: [Bool] = Array(repeating: false, count: defaultRowSizes.fiveHours)
    @Published public private(set) var singleHoursRow: [Bool] = Array(repeating: false, count: defaultRowSizes.singleHours)
    @Published public private(set) var fiveMinutesRow: [Bool] = Array(repeating: false, count: defaultRowSizes.fiveMinutes)
    @Published public private(set) var singleMinutesRow: [Bool] = Array(repeating: false, count: defaultRowSizes.singleMinutes)
    
    // MARK: Dependencies
    private let timeProvider: BerlinTimeProvider
    private let converter: BerlinClockConverter
    
    // MARK: - Timer
    private var timer: Timer?
    
    public var isTimerRunning: Bool {
        timer?.isValid ?? false
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
        let newClockState = converter.convert(_time: currentTime)
        
        updateClockState(newClockState)
    }
           
    // Starts the timer to update every second
    public func startTimer() {
        stopTimer()
        updateTime()
        
        timer = Timer.scheduledTimer(withTimeInterval:BerlinClockViewModel.timerInterval, repeats: true) { [weak self] _ in
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
    
    // Updates the clock state only if values have changed
    private func updateClockState(_ clockState: BerlinClockState) {
        if secondsLamp != clockState.secondsLamp {
                secondsLamp = clockState.secondsLamp}
            
        if fiveHoursRow != clockState.fiveHoursRow {
                fiveHoursRow = clockState.fiveHoursRow}
        
        if singleHoursRow != clockState.singleHoursRow {
                singleHoursRow = clockState.singleHoursRow}
            
        if fiveMinutesRow != clockState.fiveMinutesRow {
                fiveMinutesRow = clockState.fiveMinutesRow}
            
        if singleMinutesRow != clockState.singleMinutesRow {
                singleMinutesRow = clockState.singleMinutesRow}
        }
}
