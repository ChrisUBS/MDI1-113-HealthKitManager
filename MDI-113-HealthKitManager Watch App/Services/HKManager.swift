//
//  HKManager.swift
//  MDI-113-HealthKitManager
//
//  Created by Christian Bonilla on 06/12/25.
//

import Foundation
import HealthKit
import Combine

class HKManager: HRManagerProtocol {
    
    @Published var latestHeartRate: Double = 0
    @Published var allHeartRates: [HKQuantitySample] = []
    
    private let healthStore = HKHealthStore()
    private var anchor: HKQueryAnchor?

    init() {
        requestAuthorization()
    }
    
    func start() {
        startStreamingHeartRate()
    }
    
    private func requestAuthorization() {
        guard let hrType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }

        let typesToRead: Set<HKObjectType> = [hrType]
        let typesToShare: Set<HKSampleType> = []

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            if success {
                self.startStreamingHeartRate()
            } else {
                print("❌ HealthKit authorization failed: \(String(describing: error))")
            }
        }
    }
    
    private func startStreamingHeartRate() {
        guard let hrType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }

        let query = HKAnchoredObjectQuery(
            type: hrType,
            predicate: nil,
            anchor: anchor,
            limit: HKObjectQueryNoLimit
        ) { query, samples, deleted, newAnchor, error in
            self.process(samples: samples, newAnchor: newAnchor)
        }

        // Realtime incremental updates
        query.updateHandler = { query, samples, deleted, newAnchor, error in
            self.process(samples: samples, newAnchor: newAnchor)
        }

        healthStore.execute(query)
    }
    
    private func process(samples: [HKSample]?, newAnchor: HKQueryAnchor?) {
        DispatchQueue.main.async {
            self.anchor = newAnchor
            
            guard let samples = samples as? [HKQuantitySample], !samples.isEmpty else { return }

            // Append to history for chart UI
            self.allHeartRates.append(contentsOf: samples)

            // Extract the latest value
            if let last = samples.last {
                let bpm = last.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                self.latestHeartRate = bpm
            }
        }
    }
}
