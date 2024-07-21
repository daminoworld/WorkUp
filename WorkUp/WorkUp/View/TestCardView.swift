//
//  TestCardView.swift
//  13jo
//
//  Created by Damin on 6/15/24.
//

import SwiftUI

struct TestCardView: View {
    var shuffledCardList: [NewCard] = []
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 13)
                .fill(Color(hex: "232323"))
            
            VStack(spacing: 0) {
                (Text("퀴즈")
                    .foregroundColor(Color(hex: "53E7FB"))
                 + Text("를\n 시작해 볼까요?"))
                .font(.system(size: 40))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.top, 90)
                Spacer()
                
                NavigationLink {
                    //TODO: shuffledCardList 넣어서 CardDetail연결
                    CardDetailView(shuffledCardList: shuffledCardList)
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "53E7FB"))
                        .frame(width: 282, height: 64)
                        .overlay(alignment: .center) {
                            Text("시작하기")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                .fontWeight(.semibold)
                        }
                }
                
                NavigationLink {
                    NewCardView()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "000000"))
                        .frame(width: 282, height: 47)
                        .overlay(alignment: .center) {
                            HStack {
                                Image("AddQuiz")
                                Text("퀴즈 만들기")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                            }
                            
                        }
                }
                .padding(.top, 12)
                .padding(.bottom, 36)
            }
        }
        .frame(width: 315, height: 425)
        
    }
}

#Preview {
    TestCardView()
}
