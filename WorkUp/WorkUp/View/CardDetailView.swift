//
//  CardDetailView.swift
//  13jo
//
//  Created by sungkug_apple_developer_ac on 6/15/24.
//

import SwiftUI
import SwiftData

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

            VStack {
                if !motionManager.isDeviceFlipped {
                    Image("Arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 106, height: 106)
                        .padding(.bottom, 20)
                        
                }
                
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
                
                ZStack {
                    Rectangle()
                        .foregroundStyle(.gray.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                        .rotationEffect(.degrees(10))
                        .offset(x: motionManager.isDeviceFlipped ? 60 : -60, y: motionManager.isDeviceFlipped ? -50 : 50)
                        .frame(width: 315, height: 424)
                    
                    cardView
                        .frame(width: 315, height: 424)
                }
                .padding(.top)
                
                if motionManager.isDeviceFlipped && !motionManager.isDeviceFlippedFor5Seconds {
                    VStack {
                        Text("내용 확인하기")
                            .font(.system(size: 41, weight: .bold))
                            .padding(.bottom, 15)
                        Text("내용 확인을 위해 고개를 든 상태로\n5초간 유지해주세요.")
                            .font(.system(size: 20, weight: .semibold))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 70)
                    
                } else if motionManager.isDeviceFlipped && motionManager.isDeviceFlippedFor5Seconds {
                    
                    Image("Arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 106, height: 106)
                        .rotationEffect(.degrees(180.0))
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
    
    private func deleteCard(){
        for card in newCards{
            if card.id == shuffledCardList[currentIndex].id{
                modelContext.delete(card)
            }
        }
    }
}


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

#Preview {
    CardDetailView()
}

