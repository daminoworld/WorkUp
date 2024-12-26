//
//  TestInformationView.swift
//  13jo
//
//  Created by Damin on 6/15/24.
//

import SwiftUI

struct MainInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isInformationFirst: Bool = true
    var body: some View {
        ZStack {
            Image(isInformationFirst ? "infoFirstPage" : "infoSecondPage")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        if isInformationFirst {
                            isInformationFirst = false
                        }else {
                            dismiss()
                        }
                    }, label: {
                        Image(isInformationFirst ? "infoNextButton" : "infoCloseButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 82, height: 44)
                    })
                }
                .padding(.horizontal, 37)
                .padding(.bottom, 39)
            }
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MainInfoView()
}
