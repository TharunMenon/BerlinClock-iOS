//
//  BerlinClockView.swift
//  BerlinClock
//
//  Created by Tharun Menon on 18/02/26.
//

import SwiftUI

struct BerlinClockView: View {
    @ObservedObject private var viewModel: BerlinClockViewModel
    
    // MARK: - Constants
    private let lampSize: CGFloat = 50
    private let spacing: CGFloat = 8
    
    init(viewModel: BerlinClockViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Berlin Clock")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .padding(.top)
            
            // Seconds Lamp (top)
            secondsLampView
            
            // Five Hours Row
            hourRowView(lights: viewModel.fiveHoursRow, color: .red, label: "Hours (×5)")
            
            // Single Hours Row
            hourRowView(lights: viewModel.singleHoursRow, color: .red, label: "Hours (×1)")
            
            // Five Minutes Row
            minuteRowView(lights: viewModel.fiveMinutesRow, color: .yellow, label: "Minutes (×5)")
            
            // Single Minutes Row
            minuteRowView(lights: viewModel.singleMinutesRow, color: .yellow, label: "Minutes (×1)")
            
            Spacer()
            
            // Control Buttons
            controlButtonsView
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
    }
    
    // MARK: - View Components
    
    private var secondsLampView: some View {
        VStack {
            Text("Seconds")
                .font(.caption)
                .foregroundColor(.white)
            
            Circle()
                .fill(viewModel.secondsLamp ? Color.yellow : Color.gray.opacity(0.3))
                .frame(width: lampSize, height: lampSize)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )
        }
    }
    
    private func hourRowView(lights: [Bool], color: Color, label: String) -> some View {
        VStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.white)
            
            HStack(spacing: spacing) {
                ForEach(0..<lights.count, id: \.self) { index in
                    Rectangle()
                        .fill(lights[index] ? color : Color.gray.opacity(0.3))
                        .frame(width: lampSize, height: lampSize * 0.6)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
    }
    
    private func minuteRowView(lights: [Bool], color: Color, label: String) -> some View {
        VStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.white)
            
            HStack(spacing: spacing) {
                ForEach(0..<lights.count, id: \.self) { index in
                    Rectangle()
                        .fill(lights[index] ? (index == 2 || index == 5 || index == 8 ? .red : color) : Color.gray.opacity(0.3))
                        .frame(width: lampSize * 0.8, height: lampSize * 0.6)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
    }
    
    private var controlButtonsView: some View {
        HStack(spacing: 20) {
            Button("Start") {
                viewModel.startTimer()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isTimerRunning)
            
            Button("Stop") {
                viewModel.stopTimer()
            }
            .buttonStyle(.borderedProminent)
            .disabled(!viewModel.isTimerRunning)
        }
        .padding()
    }
}
 
// MARK: - Preview
struct PreviewTimeProvider: BerlinTimeProvider {
    func getCurrentTime() -> BerlinTime {
        return BerlinTime(hours: 14, minutes: 30, seconds: 24)
    }
}
 
#Preview {
    let previewTimeProvider = PreviewTimeProvider()
    let converter = DefaultBerlinClockConverter()
    let viewModel = BerlinClockViewModel(timeProvider: previewTimeProvider, converter: converter)
    
    BerlinClockView(viewModel: viewModel)
        .onAppear {
            viewModel.updateTime()
        }
}
 
     
