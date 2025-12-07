//
//  SettingsView.swift
//  MDI-113-HealthKitManager
//
//  Created by Christian Bonilla on 06/12/25.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("lowThreshold") private var lowThreshold: Double = 50
    @AppStorage("highThreshold") private var highThreshold: Double = 120
    
    var body: some View {
        Form {
            Section(header: Text("Low Heart Rate Threshold")) {
                
                Text("Low: \(Int(lowThreshold)) BPM")
                    .font(.subheadline)
                
                Slider(
                    value: $lowThreshold,
                    in: 30...100,
                    step: 1
                )
            }
            
            Section(header: Text("High Heart Rate Threshold")) {
                
                Text("High: \(Int(highThreshold)) BPM")
                    .font(.subheadline)

                Slider(
                    value: $highThreshold,
                    in: 80...200,
                    step: 1
                )
            }
        }
        .navigationTitle("Settings")
    }
}
