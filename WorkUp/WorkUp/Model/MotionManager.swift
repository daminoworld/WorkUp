//
//  MotionManager.swift
//  13jo
//
//  Created by sungkug_apple_developer_ac on 6/15/24.
//

import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    private var motionManager: CMMotionManager
    @Published var isDeviceFlipped: Bool = false
    @Published var timeIntervalSince: TimeInterval = 0.0
    @Published var isDeviceFlippedFor5Seconds: Bool = false

    private var flipStartTime: Date?
    private let flipDuration: TimeInterval = 5.0 // 5초
    
    init() {
        self.motionManager = CMMotionManager()
        self.motionManager.accelerometerUpdateInterval = 0.1
        
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data, error) in
                guard let data = data, error == nil else { return }
                self?.handleDeviceMotion(data: data)
            }
        }
    }
    
    private func handleDeviceMotion(data: CMAccelerometerData) {
        let acceleration = data.acceleration
        DispatchQueue.main.async {
            if acceleration.z > 0.8 {
                self.isDeviceFlipped = true
                if self.flipStartTime == nil {
                    self.flipStartTime = Date()
                } else if let startTime = self.flipStartTime {
                    self.timeIntervalSince = Date().timeIntervalSince(startTime)
                    if self.timeIntervalSince >= self.flipDuration{
                        self.isDeviceFlippedFor5Seconds = true
                    }
                }
            } else {
                self.flipStartTime = nil
                self.isDeviceFlipped = false
                self.isDeviceFlippedFor5Seconds = false
                self.timeIntervalSince = 0.0
            }
        }
    }
}
