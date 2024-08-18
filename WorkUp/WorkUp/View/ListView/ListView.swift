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
                    ListCardCell(card: item, cardIndex: index)
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

struct ListCardCell: View {
    var card: NewCard
    var cardIndex: Int
    
    var body: some View {
        VStack(alignment:.leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("\(String(format: "%02d", cardIndex + 1))")
                    .font(.system(size: 25, weight: .bold))
                    .padding(.leading, 14)
                Spacer()
                Button {
                    //삭제코드
                } label: {
                    Image(systemName: "trash")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(width: 20, height: 24)
                        .padding(.trailing, 14)
                }
            }
            .frame(height: 49)
            .background(Color(hex: "53E7FB"))
            Text("\(card.question)")
                .font(.system(size: 20, weight: .bold))
                .lineSpacing(14)
                .foregroundStyle(.white)
                .padding(.horizontal,14)
                .padding(.top, 11)
            Spacer()
        }
        .frame(width: 161, height: 217)
        .background(Color(hex: "232323"))
        .clipShape(RoundedRectangle(cornerRadius: 13))
    }
}

#Preview {
    ListView()
}
