//
//  MDI_113_HealthKitManagerApp.swift
//  MDI-113-HealthKitManager Watch App
//
//  Created by Christian Bonilla on 06/12/25.
//

import SwiftUI

@main
struct MDI_113_HealthKitManager_Watch_AppApp: App {
    let hrManager: any HRManagerProtocol = {
#if targetEnvironment(simulator)
        print("🟦 Using MOCK HR Manager")
        return HKMockManager()
#else
        print("🟥 Using REAL HK Manager")
        return HKManager()
#endif
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView(hrManager: hrManager)
        }
    }
}
