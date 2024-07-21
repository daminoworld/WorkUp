//
//  TestMainView.swift
//  13jo
//
//  Created by Damin on 6/15/24.
//

import SwiftUI
import SwiftData

struct TestMainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var newCards: [NewCard]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "171717")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Spacer()
                        Image("guideComment")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 47)
                            .overlay {
                                Text("앱을 어떻게 사용해야 하나요?")
                                    .foregroundStyle(.white)
                            }
                        
                        NavigationLink {
                            TestInformationView()
                        } label: {
                            Image("Info")
                        }
                    }
                    .padding(.top, 36)
                    .padding(.trailing, 28)
                    Spacer()
                    
                    if newCards.isEmpty {
                        EmptyTestCardView()
                    }else {
                        TestCardView(shuffledCardList: shuffledCardList())
                    }
                    Spacer()
                }
                
            }
        }
    }
    
    private func shuffledCardList() -> [NewCard] {
        var newShuffledCardList: [NewCard] = []
        newCards.forEach { card in
            newShuffledCardList.append(card)
        }
        newShuffledCardList.shuffle()
        return newShuffledCardList
    }
}

//#Preview {
//    TestMainView()
//}
