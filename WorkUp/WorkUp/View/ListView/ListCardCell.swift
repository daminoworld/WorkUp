//
//  ListCardCell.swift
//  WorkUp
//
//  Created by sungkug_apple_developer_ac on 8/18/24.
//

import SwiftUI

struct ListCardCell: View {
    @Environment(\.modelContext) var modelContext
    @State private var showAlert = false

    let card: NewCard
    let cardIndex: Int
    
    var body: some View {
        VStack(alignment:.leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("\(String(format: "%02d", cardIndex + 1))")
                    .font(.system(size: 25, weight: .bold))
                    .padding(.leading, 14)
                Spacer()
                Button {
                    showAlert = true
                } label: {
                    Image(systemName: "trash")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(width: 20, height: 24)
                        .padding(.trailing, 14)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("카드를 삭제할까요?"),
                        message: Text("삭제된 카드는 복구되지 않습니다."),
                        primaryButton: .destructive(Text("삭제")) {
                            modelContext.delete(card)
                        },
                        secondaryButton: .cancel(Text("취소"))
                    )
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
        .tint(.black)
        .frame(width: 161, height: 217)
        .background(Color(hex: "232323"))
        .clipShape(RoundedRectangle(cornerRadius: 13))
    }
}
