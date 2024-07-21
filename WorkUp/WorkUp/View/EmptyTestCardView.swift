//
//  EmptyTestCardView.swift
//  13jo
//
//  Created by Damin on 6/15/24.
//

import SwiftUI

struct EmptyTestCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 13)
                .fill(Color(hex: "232323"))           
            
            VStack(spacing: 0) {
               Text("어서오세요!")
                .font(.system(size: 40))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 33)
                
                Text("퀴즈를 만들며 스트레칭 해보세요")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                Image("EmptyTestCard")
                    .padding(.top, 27)
                    .padding(.bottom, 40)
                
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
                .padding(.bottom, 20)
            }
            .background(Color(hex: "232323"))
        }
        .frame(width: 315, height: 425)

    }
}

#Preview {
    EmptyTestCardView()
}
