//
//  EmptyTestCardView.swift
//  13jo
//
//  Created by Damin on 6/15/24.
//

import SwiftUI

struct EmptyCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 13)
                .fill(Color(hex: "232323"))           
            
            VStack(spacing: 0) {
                Text("어서오세요")
                    .foregroundColor(.white)
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .padding(.top, 41)
                
                Text("첫 카드를 만들어 볼까요?")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .padding(.top, 5)
                
                Image("MainCardImage")
                    .padding(.top, 25)
                
                NavigationLink {
                    NewCardView()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "53E7FB"))
                        .frame(width: 282, height: 64)
                        .overlay(alignment: .center) {
                            Text("퀴즈를 만들고 시작")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                .fontWeight(.semibold)
                        }
                }
                .padding(.top, 40)
                .padding(.bottom, 27)
            }
            .background(Color(hex: "232323"))
        }
        .frame(width: 315, height: 425)

    }
}

#Preview {
    EmptyCardView()
}
