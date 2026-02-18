//
//  ContentView.swift
//  BerlinClock
//
//  Created by Tharun Menon on 17/02/26.
//

import SwiftUI

struct ContentView: View {
    private let timeProvider = SystemTimeProvider()
        private let converter = DefaultBerlinClockConverter()
        
        var body: some View {
            let viewModel = BerlinClockViewModel(timeProvider: timeProvider, converter: converter)
            
            BerlinClockView(viewModel: viewModel)
                .onAppear {
                    viewModel.startTimer()
                }
        }
    }
     
    #Preview {
        ContentView()
    }
