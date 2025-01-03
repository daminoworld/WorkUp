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
    @State private var dragOffset: CGSize = .zero // 드래그 오프셋 상태 변수
    @State private var scrollId: Int? = 0
    @State var motionMode: MotionMode = .top
    @State var shuffledCardList: [NewCard] = []
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // ZStack 배경으로 전체 다 덮게 안하면 VStack 이 제대로 배치가 안됨
            Color.black
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                
                setHeaderView()
                
                GeometryReader { geo in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 0) {
                            ForEach(shuffledCardList.indices, id: \.self) { idx in
                                if motionMode == .top {
                                    RollMotionCardView(motionManager: motionManager, currentIndex: $currentIndex, shuffledCardList: shuffledCardList)
                                       
                                } else {
                                    YawMotionCardView(motionManager: motionManager, currentIndex: $currentIndex, shuffledCardList: shuffledCardList, isLeft: motionMode == .left ? true : false)
                                }
                            }
                            .frame(width: 315, height: 424)
                            .padding(.bottom, 50)
                            .padding(.horizontal, (geo.size.width - 315) / 2)
                            .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.6)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.85)
                                
                            }
                        }
                        // lazyHStack
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollPosition(id: $scrollId)
                    .onChange(of: scrollId) { oldValue, newValue in
                        guard let newValue else { return }
                        currentIndex = newValue
                        randomMode()
                    }
                    .scrollDisabled(motionManager.isDeviceFlipped ? true : false)
                    .scrollDisabled(motionManager.isYawRotated ? true : false)
                }

               
                if motionMode == .top && motionManager.isDeviceFlipped && !motionManager.isDeviceFlippedFor5Seconds {
                    VStack(spacing: 0) {
                        Text("내용 확인하기")
                            .font(.system(size: 41, weight: .bold))
                            .padding(.top, 37)
                        Text("내용 확인을 위해 고개를 든 상태로\n5초간 유지해주세요.")
                            .font(.system(size: 20, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .padding(.top, 19)
                    }
                    .offset(y: -50)
                    
                } else if motionMode == .top && motionManager.isDeviceFlipped && motionManager.isDeviceFlippedFor5Seconds {
                    
                    Image("Arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 106, height: 155)
                        .rotationEffect(.degrees(180.0))
                        .offset(y: -50)
                }
            }
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea(.all, edges: .bottom)
            .onAppear {
                shuffledCardList = getShuffledCardList()
                randomMode()
            }
        }
    }
    
    @ViewBuilder
    func setHeaderView() -> some View {
        ZStack(alignment: .top) {
            HStack {
                Spacer()
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("Close")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                })
                .padding(.trailing, 23)
            }
            
            if motionMode == .top {
                VStack(spacing: 0) {
                    if !motionManager.isDeviceFlipped {
                        Image("Arrow")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 106, height: 155)

                        Group {
                            Text("고개를")
                                .font(.system(size: 18, weight: .regular))
                            + Text(" 들어서")
                                .font(.system(size: 18, weight: .bold))
                            + Text(" 내용을 확인")
                                .font(.system(size: 18, weight: .regular))
                        }
                        .foregroundStyle(.white)
                        .offset(y: 24)
                    }
                }
            } else {
                VStack(spacing: 0) {
                    Image(motionMode == .left ? "leftArrow" : "rightArrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 184, height: 95)
                    Group {
                        Text("고개를")
                            .font(.system(size: 18, weight: .regular))
                        + Text(" 꺽어서")
                            .font(.system(size: 18, weight: .bold))
                        + Text((motionMode == .left && motionManager.xAcceleration < -0.15) || motionMode == .right && motionManager.xAcceleration > 0.15 ? " 제목으로 돌아가기" :" 내용을 확인")
                            .font(.system(size: 18, weight: .regular))
                    }
                    .foregroundStyle(.white)
                    .padding(.top, 44)
                    .offset(y: 24)
                }
            }
        }
    }
    
    func randomMode() {
        motionMode = MotionMode.allCases.randomElement()!
    }
    
    private func getShuffledCardList() -> [NewCard] {
        var newShuffledCardList: [NewCard] = []
        newCards.forEach { card in
            newShuffledCardList.append(card)
        }
        newShuffledCardList.shuffle()
        return newShuffledCardList
    }
}

#Preview {
    CardDetailView()
}
