//
//  RollMotionCardView.swift
//  WorkUp
//
//  Created by Damin on 9/7/24.
//

import SwiftUI

struct RollMotionCardView: View {
    @ObservedObject var motionManager: MotionManager
    @Binding var currentIndex: Int
    @State var shuffledCardList: [NewCard]
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundStyle(.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                .rotationEffect(.degrees(10))
                .offset(x: motionManager.isDeviceFlipped ? 60 : -60, y: motionManager.isDeviceFlipped ? -50 : 50)
                .frame(width: 315, height: 424)
            
            Rectangle()
                .foregroundStyle(motionManager.isDeviceFlipped ? Color("MainColor") : .white)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                .shadow(color: .black, radius: 10, x: 0, y: 5)

            if motionManager.isDeviceFlipped && !motionManager.isDeviceFlippedFor5Seconds{
                ProgressRingView(progress: $motionManager.timeIntervalSince)
            } else if motionManager.isDeviceFlipped && motionManager.isDeviceFlippedFor5Seconds{
                CardContentView(isAnswer: true, content: shuffledCardList[currentIndex].question, index: currentIndex, totalNum: shuffledCardList.count)
            } else {
                CardContentView(content: shuffledCardList[currentIndex].question, index: currentIndex, totalNum: shuffledCardList.count)
            }
        }
        .animation(.easeInOut, value: motionManager.isDeviceFlipped)
    }
}
