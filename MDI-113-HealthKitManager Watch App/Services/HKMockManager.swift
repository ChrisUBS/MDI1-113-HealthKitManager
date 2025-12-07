//
//  HKMockManager.swift
//  MDI-113-HealthKitManager
//
//  Created by Christian Bonilla on 06/12/25.
//

import Foundation
import HealthKit
import Combine

class HKMockManager: HRManagerProtocol {
    
    @Published var latestHeartRate: Double = 75
    @Published var allHeartRates: [HKQuantitySample] = []
    
    private var timer: Timer?
    
    /// Start generating simulated heart rate values
    func start() {
        startMockHRStream()
    }
    
    // -------------------------------------------------------------
    // MARK: MOCK HEART RATE STREAM (SIMULATOR ONLY)
    // -------------------------------------------------------------
    private func startMockHRStream() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let newBPM = self.generateSmoothMockValue()
            self.publishMockSample(bpm: newBPM)
        }
    }
    
    private func generateSmoothMockValue() -> Double {
        // Slight oscillation instead of pure random jitter
        let random = Double.random(in: -5...5)
        var newValue = latestHeartRate + random
        
        // Clamp to safe range
        newValue = max(55, min(130, newValue))
        return newValue
    }
    
    private func publishMockSample(bpm: Double) {
        DispatchQueue.main.async {
            self.latestHeartRate = bpm

            // Create a fake HKQuantitySample for the chart
            let quantity = HKQuantity(
                unit: HKUnit.count().unitDivided(by: .minute()),
                doubleValue: bpm
            )
            
            let sample = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .heartRate)!,
                quantity: quantity,
                start: Date(),
                end: Date()
            )
            
            self.allHeartRates.append(sample)
        }
    }
}
