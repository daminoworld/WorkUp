//
//  CardContentView.swift
//  WorkUp
//
//  Created by sungkug_apple_developer_ac on 8/21/24.
//

import SwiftUI

struct CardContentView: View {
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
