//
//  ContentView.swift
//  MDI-113-HealthKitManager
//
//  Created by Christian Bonilla on 06/12/25.
//

import SwiftUI
import Charts
import HealthKit

struct ContentView: View {
    
    // MANAGER: real or mock
    var hrManager: any HRManagerProtocol
    @State private var refreshTick = false
    
    // User-defined thresholds
    @AppStorage("lowThreshold") private var lowThreshold: Double = 50
    @AppStorage("highThreshold") private var highThreshold: Double = 120
    
    // -------------------------------------------------------------
    // MARK: HEART RATE STATE INTERPRETATION
    // -------------------------------------------------------------
    var heartColor: Color {
        if hrManager.latestHeartRate > highThreshold { return .red }
        if hrManager.latestHeartRate < lowThreshold { return .blue }
        return .green
    }
    
    var statusText: String {
        if hrManager.latestHeartRate > highThreshold { return "⚠️ High!" }
        if hrManager.latestHeartRate < lowThreshold { return "⚠️ Low!" }
        return "Normal"
    }
    
    // -------------------------------------------------------------
    // MARK: UI
    // -------------------------------------------------------------
    var body: some View {
        NavigationStack {
            VStack(spacing: 6) {
                
                // CURRENT BPM
                Text("\(Int(hrManager.latestHeartRate)) BPM")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(heartColor)
                
                Text(statusText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                Divider().padding(.vertical, 4)
                
                // HEART RATE CHART
                if !hrManager.allHeartRates.isEmpty {
                    Chart(hrManager.allHeartRates, id: \.startDate) { sample in
                        LineMark(
                            x: .value("Time", sample.startDate),
                            y: .value("BPM",
                                      sample.quantity.doubleValue(
                                          for: HKUnit.count().unitDivided(by: .minute())
                                      )
                            )
                        )
                        .foregroundStyle(.red)
                    }
                    .frame(height: 70)
                } else {
                    Text("Waiting for data…")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                Spacer(minLength: 4)
                
                // SETTINGS BUTTON
                NavigationLink("Settings") {
                    SettingsView()
                }
                .buttonStyle(.bordered)
                .font(.caption)
            }
            .padding(.horizontal, 8)
            .padding(.top, 6)
            .onAppear {
                hrManager.start()   // Start real or mock stream
            }
        }
    }
}
