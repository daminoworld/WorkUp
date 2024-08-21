//
//  YawMotionCardView.swift
//  WorkUp
//
//  Created by sungkug_apple_developer_ac on 8/21/24.
//

import SwiftUI

struct YawMotionCardView: View {
    @ObservedObject var motionManager: MotionManager
    @State var isLeft = true
    @State var currentIndex = 0
    @State var shuffledCardList: [NewCard] = Array(repeating: NewCard(question: "", answer: ""), count: 100)

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
    }
    
    var answerCard: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color("MainColor"))
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                .shadow(color: .black, radius: 10, x: 0, y: 5)
            
            cardContentView(isAnswer: true, content: shuffledCardList[currentIndex].question, index: currentIndex, totalNum: shuffledCardList.count)
        }
    }
    
    var QuestionCard: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                .shadow(color: .black, radius: 10, x: 0, y: 5)
            cardContentView(content: shuffledCardList[currentIndex].question, index: currentIndex, totalNum: shuffledCardList.count)
        }
    }
}

struct cardContentView: View {
    var isAnswer = false
    var content: String
    var index: Int
    var totalNum: Int
    
    var body: some View {
        VStack {
            HStack {
                Text(isAnswer ? "Content" : "Title")
                    .font(.system(size: 45))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                Spacer()
                Group {
                    Text("\(index + 1)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(isAnswer ? .white : .black)
                    + Text("/\(totalNum)")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(isAnswer ? .white : Color("CardCount"))
                }
            }
            Text("\(content)")
                .font(.system(size: 38 , weight: .bold))
                .foregroundStyle(.black)
                .lineSpacing(4)
                .tracking(-0.4)
                .padding(.top, 43)
            Spacer()
        }
        .padding(30)
    }
}

#Preview {
    YawMotionCardView(motionManager: MotionManager())
}
