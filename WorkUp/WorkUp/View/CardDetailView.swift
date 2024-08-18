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

    var body: some View {
        VStack {

            Spacer()
            if !motionManager.isDeviceFlipped{
                ZStack{
                    Spacer()
                    Image("Arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 106, height: 106)
                        .padding(.bottom, 20)
                    Spacer()
                    HStack{
                        Spacer()
                        VStack{
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Image(isLastQuiz ? "Activeclose" : "Close")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, height: 35)
                            })
                            Spacer()
                        }
                    }
                }
                
                if isLastQuiz {
                    Text("모든 카드가 끝났습니다")
                } else {
                    Group {
                        Text("고개를")
                            .font(.system(size: 18, weight: .regular))
                        + Text(" 들어서")
                            .font(.system(size: 18, weight: .bold))
                        + Text(" 내용을 확인")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(isLastQuiz ? Color("MainColor") :.white)
                    }
                    .padding(.bottom, 20)
                  
                }
            }
            card
                .padding(.bottom, 55)
                .animation(.easeInOut, value: motionManager.isDeviceFlipped)
//                .alert(isPresented: $showAlert) {
//                    Alert(title: Text("Title"), message: Text("This is a alert message"), dismissButton: .default(Text("Dismiss")))
//                }
//                .alert("현재 퀴즈를 삭제하시겠습니까?", isPresented: $showAlert) {
//                    Button("삭제", role: .destructive) {
//                        deleteCard()
//                    }
//                    Button("취소", role: .cancel) {
//                        showAlert =
//                }
            if !motionManager.isDeviceFlipped {
                Button(action: {
                    if currentIndex < shuffledCardList.count - 1{
                        currentIndex += 1
                        if currentIndex == shuffledCardList.count - 1{
                            isLastQuiz = true
                        }
                    }
                }, label: {
                    HStack{
                        Spacer()
                        Text("다음")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    .frame(height: 64)
                    .background(isLastQuiz ? Color("DisabledColor") : Color("MainColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.bottom, 50)
                })
                .disabled(isLastQuiz)
            } else if !motionManager.isDeviceFlippedFor5Seconds{
                VStack{
                    Text("내용 확인하기")
                        .font(.system(size: 41, weight: .bold))
                        .padding(.bottom, 15)
                    Text("내용 확인을 위해 고개를 든 상태로\n5초간 유지해주세요.")
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 70)
            } else {
                Image("Arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 106, height: 106)
                    .rotationEffect(.degrees(180.0))
            }
        }
        .padding()
        .background(.black)
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            if shuffledCardList.count == 1{
                isLastQuiz = true
            }
        })
        
    }
    
    var card: some View {
        
        ZStack{
            Rectangle()
                .foregroundStyle(.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                .rotationEffect(.degrees(10))
                .offset(x: motionManager.isDeviceFlipped ? 60 :-40, y: motionManager.isDeviceFlipped ? -50 : 20)
            Rectangle()
                .foregroundStyle(motionManager.isDeviceFlipped ? Color("MainColor") : .white)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                .shadow(color: .black, radius: 10, x: 0, y: 5)
            if motionManager.isDeviceFlipped && !motionManager.isDeviceFlippedFor5Seconds{
                ProgressRingView(progress: $motionManager.timeIntervalSince)
            } else {
                quiz
            }
        }
        .frame(width: 315, height: 424)
    }
    
    var quiz: some View {
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

