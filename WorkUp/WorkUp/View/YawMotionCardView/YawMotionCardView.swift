//
//  YawMotionCardView.swift
//  WorkUp
//
//  Created by sungkug_apple_developer_ac on 8/21/24.
//

import SwiftUI

struct YawMotionCardView: View {
    @ObservedObject var motionManager: MotionManager
    @Binding var motionMode: MotionMode
    @Binding var currentIndex: Int
    @Binding var shuffledCardList: [NewCard]
    @State var isLeft = true

    var rotationAngle: Double {
        let maxAngle = isLeft ? -25.0 : 25.0
        let minAcceleration = isLeft ? motionManager.minXAcceleration : motionManager.maxXAcceleration
        var normalizedAcceleration = motionManager.xAcceleration > 0 ? 0 : motionManager.xAcceleration

        if !isLeft {
            normalizedAcceleration = motionManager.xAcceleration < 0 ? 0 : motionManager.xAcceleration
        }
        
        let angle = (1 - normalizedAcceleration / minAcceleration) * maxAngle
        return angle
    }

    var rotationOffset: (Double, Double) {
        let minX = isLeft ? -200.0 : 200.0
        let minY = isLeft ? 30.0 : -30.0
        let minAcceleration = isLeft ? motionManager.minXAcceleration : motionManager.maxXAcceleration
        var normalizedAcceleration = motionManager.xAcceleration > 0 ? 0 : motionManager.xAcceleration
        if !isLeft {
            normalizedAcceleration = motionManager.xAcceleration < 0 ? 0 : motionManager.xAcceleration
        }
        
        let offsetX = (1 - normalizedAcceleration /  minAcceleration) * minX
        let offsetY = (1 - normalizedAcceleration / minAcceleration) * minY
        
        return (offsetX, offsetY)
    }
    
    var body: some View {
        ZStack {
            answerCard
                .frame(width: 315, height: 424)
                .rotationEffect(.degrees(rotationAngle))
                .offset(x: rotationOffset.0 , y: rotationOffset.1)
                .opacity(abs(rotationAngle) > 5 ? 0.3 : 1)
                .zIndex(abs(rotationAngle) > 5 ? 0 : 1)
                .animation(.easeInOut, value: motionManager.xAcceleration)

            QuestionCard
                .frame(width: 315, height: 424)
                .opacity(abs(rotationAngle) > 5 ? 1 : 0.3)
                .animation(.easeInOut, value: motionManager.xAcceleration)
        }
        .onChange(of: motionMode) {
            if motionMode == .left {
                isLeft = true
            } else {
                isLeft = false
            }
        }
    }
    
    var answerCard: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color("MainColor"))
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                .shadow(color: .black, radius: 10, x: 0, y: 5)
            
            CardContentView(isAnswer: true, content: shuffledCardList[currentIndex].question, index: currentIndex, totalNum: shuffledCardList.count)
        }
    }
    
    var QuestionCard: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                .shadow(color: .black, radius: 10, x: 0, y: 5)
            CardContentView(content: shuffledCardList[currentIndex].question, index: currentIndex, totalNum: shuffledCardList.count)
        }
    }
}
