//
//  CardDetailView.swift
//  13jo
//
//  Created by sungkug_apple_developer_ac on 6/15/24.
//

import SwiftUI
import SwiftData
enum MotionMode: CaseIterable {
    case top, left, right
}

struct CardDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext
    @Query var newCards: [NewCard]
    @StateObject private var motionManager = MotionManager()
    @State var quizModel: String = "나는 누굴까요?"
    @State private var showAlert = false
    @State var currentIndex = 0
    @State var isLastQuiz = false
    @State var shuffledCardList: [NewCard] = Array(repeating: NewCard(question: "", answer: ""), count: 100)
    @State private var dragOffset: CGSize = .zero // 드래그 오프셋 상태 변수
    @State var motionMode: MotionMode = .left
    
    var body: some View {
        ZStack(alignment: .top) {
            // TODO: 닫기 버튼 삭제 문의 필요
//            VStack {
//                HStack {
//                    Spacer()
//                    
//                    Button(action: {
//                        self.presentationMode.wrappedValue.dismiss()
//                    }, label: {
//                        Image(isLastQuiz ? "Activeclose" : "Close")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 35, height: 35)
//                    })
//                    
//                }
//                Spacer()
//            }
            // ZStack 배경으로 전체 다 덮게 안하면 VStack 이 제대로 배치가 안됨
            Color.black
                .ignoresSafeArea(.all)

            VStack(spacing: 0) {
                if motionMode == .top {
                    topHeader
                    ZStack {
                        //백그라운드 카드
                        Rectangle()
                            .foregroundStyle(.gray.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                            .rotationEffect(.degrees(10))
                            .offset(x: motionManager.isDeviceFlipped ? 60 : -60, y: motionManager.isDeviceFlipped ? -50 : 50)
                            .frame(width: 315, height: 424)
                        cardView
                            .frame(width: 315, height: 424)
                    }
                    .padding(.top, motionManager.isDeviceFlipped ? 60 : 20)
                    
                    if motionManager.isDeviceFlipped && !motionManager.isDeviceFlippedFor5Seconds {
                        VStack(spacing: 0) {
                            Text("내용 확인하기")
                                .font(.system(size: 41, weight: .bold))
                                .padding(.top, 37)
                            Text("내용 확인을 위해 고개를 든 상태로\n5초간 유지해주세요.")
                                .font(.system(size: 20, weight: .semibold))
                                .multilineTextAlignment(.center)
                                .padding(.top, 19)
                        }
                        
                    } else if motionManager.isDeviceFlipped && motionManager.isDeviceFlippedFor5Seconds {
                        
                        Image("arrow")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 106, height: 155)
                            .rotationEffect(.degrees(180.0))
                            .padding(.top, 52)
                    }
                    
                } else {
                    sideHeader
                    YawMotionCardView(motionManager: motionManager, motionMode: $motionMode, currentIndex: $currentIndex, shuffledCardList: $shuffledCardList)
                        .padding(.top, 21.75)
                    //임시 드래그
                        .gesture(
                            // 왼쪽으로 스와이프 감지
                            DragGesture(minimumDistance: 20)
                                .onChanged { value in
                                    // 드래그할 때의 위치 업데이트
                                    self.dragOffset = value.translation
                                }
                                .onEnded { value in
                                    if value.translation.width < 0 {
                                        if currentIndex < shuffledCardList.count - 1{
                                            currentIndex += 1
                                            if currentIndex == shuffledCardList.count - 1{
                                                isLastQuiz = true
                                            }
                                        }
                                    }
                                    // 오른쪽으로 스와이프 감지
                                    if value.translation.width > 0 {
                                        if currentIndex > 0 {
                                            currentIndex -= 1
                                        }
                                        if isLastQuiz {
                                            isLastQuiz = false
                                        }
                                    }
                                    //랜덤 모션모드 로직임시로 배치
                                    randomMode()
                                    self.dragOffset = .zero
                                }
                        )
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                if shuffledCardList.count == 1{
                    isLastQuiz = true
                }
            }
        }
    }
    
    var topHeader: some View {
        VStack(spacing: 0) {
            if !motionManager.isDeviceFlipped {
                Image("arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 106, height: 155)
                    .padding(.bottom, 20)
                
                if isLastQuiz {
                    Text("모든 카드가 끝났습니다")
                        .foregroundStyle(isLastQuiz ? Color("MainColor") :.white)
                        .padding(.bottom, 20)
                } else {
                    Group {
                        Text("고개를")
                            .font(.system(size: 18, weight: .regular))
                        + Text(" 들어서")
                            .font(.system(size: 18, weight: .bold))
                        + Text(" 내용을 확인")
                            .font(.system(size: 18, weight: .regular))
                    }
                    .foregroundStyle(isLastQuiz ? Color("MainColor") :.white)
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    var sideHeader: some View {
        VStack(spacing: 0) {
            Image(motionMode == .left ? "leftArrow" : "rightArrow")
                .resizable()
                .scaledToFit()
                .frame(width: 177, height: 95)
                .padding(.bottom, 15.82)
            Group {
                Text("고개를")
                    .font(.system(size: 18, weight: .regular))
                + Text(" 꺽어서")
                    .font(.system(size: 18, weight: .bold))
                + Text((motionMode == .left && motionManager.xAcceleration < -0.15) || motionMode == .right && motionManager.xAcceleration > 0.15 ? "제목으로 돌아가기" :" 내용을 확인")
                    .font(.system(size: 18, weight: .regular))
            }
            .foregroundStyle(.white)
            .padding(.top, 44.4)
        }
    }
    
    var cardView: some View {
        ZStack{
            Rectangle()
                .foregroundStyle(motionManager.isDeviceFlipped ? Color("MainColor") : .white)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                .shadow(color: .black, radius: 10, x: 0, y: 5)
            if motionManager.isDeviceFlipped && !motionManager.isDeviceFlippedFor5Seconds{
                ProgressRingView(progress: $motionManager.timeIntervalSince)
            } else {
                cardContentView
            }
        }
        .offset(CGSize(width: dragOffset.width, height: 0))
        .rotationEffect(.degrees(Double(dragOffset.width) * -0.1))
        .animation(.easeInOut, value: motionManager.isDeviceFlipped)
        .gesture(
            // 왼쪽으로 스와이프 감지
            DragGesture(minimumDistance: 20)
                .onChanged { value in
                    // 드래그할 때의 위치 업데이트
                    self.dragOffset = value.translation
                }
                .onEnded { value in
                    if value.translation.width < 0 {
                        if currentIndex < shuffledCardList.count - 1{
                            currentIndex += 1
                            if currentIndex == shuffledCardList.count - 1{
                                isLastQuiz = true
                            }
                        }
                    }
                    // 오른쪽으로 스와이프 감지
                    if value.translation.width > 0 {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        }
                        if isLastQuiz {
                            isLastQuiz = false
                        }
                    }
                    //랜덤 모션모드 로직임시로 배치
                    randomMode()
                    self.dragOffset = .zero
                }
        )
    }
    
    // 카드 내부 내용
    var cardContentView: some View {
        VStack{
            HStack{
                Text(motionManager.isDeviceFlipped ? "Content" : "Title")
                    .font(.system(size: 45))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                Spacer()
                Group {
                    Text("\(currentIndex + 1)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(motionManager.isDeviceFlipped ? .white : .black)
                    + Text("/\(shuffledCardList.count)")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(motionManager.isDeviceFlipped ? .white : Color("CardCount"))
                }
            }
            Text("\(motionManager.isDeviceFlipped ? shuffledCardList[currentIndex].answer : shuffledCardList[currentIndex].question)")
                .font(.system(size: motionManager.isDeviceFlipped ? 20 : 38 , weight: .bold))
                .foregroundStyle(.black)
                .lineSpacing(motionManager.isDeviceFlipped ? 21 : 4)
                .tracking(-0.4)
                .padding(.top, 43)
            Spacer()
        }
        .padding(30)
    }
    
    func randomMode() {
        motionMode = MotionMode.allCases.randomElement()!
    }
    
}

#Preview {
    CardDetailView()
}

