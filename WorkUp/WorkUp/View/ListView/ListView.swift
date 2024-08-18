//
//  ListView.swift
//  WorkUp
//
//  Created by sungkug_apple_developer_ac on 8/18/24.
//

import SwiftData
import SwiftUI

struct ListView: View {
    @Environment(\.dismiss) private var dismiss
    @Query var cards: [NewCard]
        
    let columns = [
        GridItem(.adaptive(minimum: 161), spacing: 27)
    ]

    var body: some View {
        ScrollView {
            Image("listtitle")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
            if cards.isEmpty {
                Text("카드를 생성해주세요")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.top, 50)
            }
            LazyVGrid(columns: columns, spacing: 25) {
                ForEach(Array(cards.enumerated()), id: \.element) { index, item in
                    NavigationLink {
                        NewCardView(card: item, question: item.question, answer: item.answer, isEdit: true)
                    } label: {
                        ListCardCell(card: item, cardIndex: index)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 40)

        }
        .background(Color(hex: "171717"))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
        }, trailing: NavigationLink(destination: {
            NewCardView()
        }, label: {
            Image("AddQuiz")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }))
        
    }
}

#Preview {
    ListView()
}
