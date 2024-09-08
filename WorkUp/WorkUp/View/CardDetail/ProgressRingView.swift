//
//  ProgressRingView.swift
//  WorkUp
//
//  Created by sungkug_apple_developer_ac on 8/21/24.
//

import SwiftUI

struct ProgressRingView: View {
    @Binding var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color(.gray))
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress / 5, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress / 5)
            Text(String(format: "%.0f", min(progress, 5.0)))
                .font(.system(size: 110, weight: .bold))
                .foregroundColor(Color.black)
        }
        .padding(40)
    }
}
