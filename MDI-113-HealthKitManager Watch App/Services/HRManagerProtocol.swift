//
//  HRManagerProtocol.swift
//  MDI-113-HealthKitManager
//
//  Created by Christian Bonilla on 06/12/25.
//

import Foundation
import HealthKit

/// Interface that both REAL and MOCK heart rate manager must implement.
protocol HRManagerProtocol: ObservableObject {

    /// Latest heart rate value
    var latestHeartRate: Double { get set }

    /// Historical heart rate samples (for charts)
    var allHeartRates: [HKQuantitySample] { get set }

    /// Starts streaming (real or mock)
    func start()
}
