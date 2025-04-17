//
//  FirebaseAnalyticsManager.swift
//  WorkUp
//
//  Created by sungkug_apple_developer_ac on 4/17/25.
//

import Foundation
import FirebaseAnalytics

final class FirebaseAnalyticsManager {
    
    static let shared = FirebaseAnalyticsManager()
    private var screenEnterTime: Date?
    
    // 커스텀 이벤트 로깅
    func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }

    // 화면 체류 시간 기록
    func startScreenTimer() {
        screenEnterTime = Date()
    }

    func endScreenTimer(screenName: String) {
        guard let start = screenEnterTime else { return }
        let duration = Date().timeIntervalSince(start)
        logEvent("screen_duration", parameters: [
            "screen": screenName,
            "duration_sec": duration
        ])
        screenEnterTime = nil
    }
}
