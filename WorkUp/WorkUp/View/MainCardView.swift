//
//  TestCardView.swift
//  13jo
//
//  Created by Damin on 6/15/24.
//

import SwiftUI

struct MainCardView: View {
    var shuffledCardList: [NewCard] = []
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 13)
                .fill(Color(hex: "232323"))
            
            VStack(spacing: 0) {
                (Text("스트레칭")
                    .foregroundColor(Color.main)
                 + Text("하면서 보는")
                    .foregroundColor(.white)
                )
                .font(.system(size: 20))
                .fontWeight(.bold)
                .padding(.top, 35)
                
                Text("나만의 카드")
                    .foregroundStyle(.white)
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .padding(.top, 4)
                
                Image("MainCardImage")
                
                NavigationLink {
                    //TODO: shuffledCardList 넣어서 CardDetail연결
                    CardDetailView(shuffledCardList: shuffledCardList)
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.main)
                        .frame(width: 282, height: 60)
                        .overlay(alignment: .center) {
                            Text("보러가기")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                .fontWeight(.semibold)
                        }
                }
                .padding(.top, 32)
                
                NavigationLink {
//                    NewCardView()
                    ListView()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black)
                        .frame(width: 282, height: 47)
                        .overlay(alignment: .center) {
                            HStack {
                                Image("list")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                                Text("카드 목록")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                            }
                            
                        }
                }
                .padding(.top, 12)
                .padding(.bottom, 19)
            }
        }
        .frame(width: 315, height: 425)
        
    }
}

#Preview {
    MainCardView()
}
