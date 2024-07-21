//
//  TestInformationView.swift
//  13jo
//
//  Created by Damin on 6/15/24.
//

import SwiftUI

struct TestInformationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isInformationFirst: Bool = true
    var body: some View {
        ZStack {
            Image(isInformationFirst ? "information1" : "information2")
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button(action: {
                        if !isInformationFirst {
                            isInformationFirst = true
                        }else {
                            dismiss()
                        }
                    }, label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 13, height: 22)
                            .foregroundStyle(Color(hex: isInformationFirst ? "FBF8F3" : "53E7FB"))
                    })
                    
                    Spacer()
                    Button(action: {
                        if isInformationFirst {
                            isInformationFirst = false
                        }else {
                            dismiss()
                        }
                    }, label: {
                        if isInformationFirst {
                            Text("다음")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: "3F3F3F"))
                        } else {
                            Text("닫기")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: "53E7FB"))
                        }
                        
                    })

                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                
                Spacer()
            }
            
            
        }
        .navigationBarBackButtonHidden()
        

    }
}

#Preview {
    TestInformationView()
}
