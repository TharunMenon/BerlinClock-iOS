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
    private struct LayoutConstants {
        static let baseLampSize: CGFloat = 50
        static let spacing: CGFloat = 6
        static let cornerRadius: CGFloat = 8
        static let smallCornerRadius: CGFloat = 6
        static let strokeWidth: CGFloat = 1
        static let secondsLampStrokeWidth: CGFloat = 2
        static let sectionSpacing: CGFloat = 20
        static let titlePadding: CGFloat = 16
    }
    
    init(viewModel: BerlinClockViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: LayoutConstants.sectionSpacing) {
                // Title
                Text("Berlin Clock")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, LayoutConstants.titlePadding)
                
                // Clock sections
                VStack(spacing: LayoutConstants.sectionSpacing) {
                    // Seconds Lamp (top)
                    secondsLampView(geometry: geometry)
                    
                    // Five Hours Row
                    hourRowView(
                        lights: viewModel.fiveHoursRow,
                        color: .red,
                        label: "Hours (×5)",
                        geometry: geometry
                    )
                    
                    // Single Hours Row
                    hourRowView(
                        lights: viewModel.singleHoursRow,
                        color: .red,
                        label: "Hours (×1)",
                        geometry: geometry
                    )
                    
                    // Five Minutes Row
                    minuteRowView(
                        lights: viewModel.fiveMinutesRow,
                        color: .yellow,
                        label: "Minutes (×5)",
                        geometry: geometry
                    )
                    
                    // Single Minutes Row
                    minuteRowView(
                        lights: viewModel.singleMinutesRow,
                        color: .yellow,
                        label: "Minutes (×1)",
                        geometry: geometry
                    )
                }
                
                Spacer()
            }
        }
        .padding()
        .background(liquidGlassyBackground)
        .onAppear {
            viewModel.startTimer()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
    }
    
    // MARK: - Background
    
    private var liquidGlassyBackground: some View {
        ZStack {
            // Base black background
            Color.black
            
            // Liquid gradient overlay
            LinearGradient(
                colors: [
                    Color.black,
                    Color.gray.opacity(0.3),
                    Color.black,
                    Color.white.opacity(0.1),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(0.7)
            
            // Animated liquid bubbles
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .offset(
                        x: CGFloat(index * 150 - 150),
                        y: CGFloat(index * 200 - 200)
                    )
                    .blur(radius: 20)
            }
            
            // Glass effect overlay
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.05),
                            Color.clear,
                            Color.white.opacity(0.02)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .ignoresSafeArea()
    }
    
    // MARK: - View Components
    
    private func secondsLampView(geometry: GeometryProxy) -> some View {
        let lampSize = min(LayoutConstants.baseLampSize, geometry.size.width * 0.12)
        
        return VStack {
            Text("Seconds")
                .font(.caption)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Circle()
                .fill(viewModel.secondsLamp ? Color.yellow : Color.gray.opacity(0.3))
                .frame(width: lampSize, height: lampSize)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: LayoutConstants.secondsLampStrokeWidth)
                )
        }
        .frame(maxWidth: .infinity)
    }
    
    private func hourRowView(lights: [Bool], color: Color, label: String, geometry: GeometryProxy) -> some View {
        let lampWidth = calculateLampWidth(for: lights.count, geometry: geometry)
        let lampHeight = lampWidth * 0.6
        
        return VStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            HStack(spacing: LayoutConstants.spacing) {
                ForEach(0..<lights.count, id: \.self) { index in
                    Rectangle()
                        .fill(lights[index] ? color : Color.gray.opacity(0.3))
                        .frame(width: lampWidth, height: lampHeight)
                        .cornerRadius(LayoutConstants.cornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius)
                                .stroke(Color.white.opacity(0.3), lineWidth: LayoutConstants.strokeWidth)
                        )
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func minuteRowView(lights: [Bool], color: Color, label: String, geometry: GeometryProxy) -> some View {
        let lampWidth = calculateLampWidth(for: lights.count, geometry: geometry, isMinuteRow: true)
        let lampHeight = lampWidth * 0.6
        
        return VStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            HStack(spacing: LayoutConstants.spacing) {
                ForEach(0..<lights.count, id: \.self) { index in
                    Rectangle()
                        .fill(lampColor(for: index, isOn: lights[index], baseColor: color))
                        .frame(width: lampWidth, height: lampHeight)
                        .cornerRadius(LayoutConstants.smallCornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: LayoutConstants.smallCornerRadius)
                                .stroke(Color.white.opacity(0.3), lineWidth: LayoutConstants.strokeWidth)
                        )
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Helper Methods
    
    private func calculateLampWidth(for count: Int, geometry: GeometryProxy, isMinuteRow: Bool = false) -> CGFloat {
        let availableWidth = geometry.size.width - (2 * 16) // padding
        let totalSpacing = CGFloat(count - 1) * LayoutConstants.spacing
        let maxLampWidth = (availableWidth - totalSpacing) / CGFloat(count)
        
        // For minute rows (especially the 11-lamp row), use smaller size
        let baseLampSize = isMinuteRow ? LayoutConstants.baseLampSize * 0.8 : LayoutConstants.baseLampSize
        
        return min(baseLampSize, maxLampWidth)
    }
    
    private func lampColor(for index: Int, isOn: Bool, baseColor: Color) -> Color {
        guard isOn else { return Color.gray.opacity(0.3) }
        
        // Quarter-hour indicators (3rd, 6th, 9th positions - 0-indexed: 2, 5, 8)
        let quarterHourPositions = [2, 5, 8]
        return quarterHourPositions.contains(index) ? .red : baseColor
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
}
 
     
