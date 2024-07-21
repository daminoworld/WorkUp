//
//  newCardView.swift
//  13jo
//
//  Created by Shim Hyeonhee on 6/15/24.
//


import SwiftUI
import SwiftData

struct NewCardView: View {
    @Environment(\.modelContext) var modelContext 
    @State private var question = ""
    @State private var answer = ""
    @Environment(\.dismiss) private var dismiss
    
    
    let limitCount = 100
    let buttonColor = Color(r: 83, g: 231, b: 251)
    let textfieldColor = Color(r: 35, g: 35, b: 35)
    let textlabelColor = Color(r: 82, g: 82, b: 82)
    let placeholderColor = Color(r: 100, g: 100, b: 100)
   
    var body: some View {
        
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
                 
            VStack {
                Spacer()
                    .frame(height: 125)
                VStack(alignment:.leading) {
                    VStack(alignment: .leading, spacing: 15){
                        Text("퀴즈를")
                            .foregroundColor(buttonColor)
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                        Text("만들어주세요!")
                            .foregroundColor(.white)
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                    } 
                   
                    Spacer()
                        .frame(height: 38)
                    
                    VStack{
                        HStack {
                            Text("퀴즈")
                                .foregroundColor(textlabelColor)
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            + Text("문제")
                                .foregroundColor(buttonColor)
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(question.count) / \(limitCount)자")
                                .font(.system(size: 15))
                        }.padding(.leading, 10)
                        
                        ZStack(alignment: .topLeading) {
                            let placeholder: String = "문제를 입력해 주세요"
                            
                            TextEditor(text: $question)
                                .maxLength(text: $question, limitCount)
                                .font(.system(size: 15))
                                .scrollContentBackground(.hidden)
                                .foregroundColor(.white)
                                .padding(.leading, 10)
                                .padding(.top, 11)
                                .background(textfieldColor)
                                .frame(width: 310, height: 148)
                                .cornerRadius(10)
                                .lineSpacing(10.0)
                            
                            if question.isEmpty {
                                Text(placeholder)
                                    .font(.system(size: 15))
                                    .foregroundColor(placeholderColor)
                                    .padding(.leading, 15)
                                    .padding(.top, 21)
                            }
                        }
                       
                    }
                    
                    Spacer()
                        .frame(height: 23)
                    
                    VStack {
                        HStack {
                            Text("퀴즈")
                                .foregroundColor(textlabelColor)
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            + Text("정답")
                                .foregroundColor(buttonColor)
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            
                            Spacer()
                            Text("\(answer.count) / \(limitCount)자")
                                .font(.system(size: 15))
                        }
                        .padding(.leading, 10)
                        ZStack(alignment: .topLeading) {
                            let placeholder: String = "정답을 작성해 주세요"
                        
                        TextEditor(text: $answer)
                            .maxLength(text: $answer, limitCount)
                            .font(.system(size: 15))
                            .scrollContentBackground(.hidden)
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                            .padding(.top, 11)
                            .background(textfieldColor)
                            .frame(width: 310, height: 148)
                            .cornerRadius(10)
                            .lineSpacing(10.0)
                            
                        if answer.isEmpty {
                            Text(placeholder)
                                .font(.system(size: 15))
                                .foregroundColor(placeholderColor)
                                .padding(.leading, 15)
                                .padding(.top, 21)
                        }
                    }
                    }
                }
                .foregroundColor(.white)
               
                .padding(.horizontal, 40)
                
                Spacer()
                    .frame(height: 50)
                
                
                Button {
                    let newCard = NewCard(question: question, answer: answer)
                    modelContext.insert(newCard)
                    dismiss()
                } label: {
                    Text("문제 추가하기")
                        .fontWeight(.semibold)
                        .frame(width: 354, height: 64)
                        .background(buttonColor)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .font(.system(size: 20))
                } 
                .padding(.vertical, 22)
                .disabled(question.trimmingCharacters(in: .whitespaces).isEmpty)
                .disabled(answer.trimmingCharacters(in: .whitespaces).isEmpty)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white) // Custom back button color
                        })
                Spacer()
                    .frame(height: 50)
                
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
       
           
       
        
      
    }
}




