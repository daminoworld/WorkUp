//
//  TextEditor+.swift
//  13jo
//
//  Created by sungkug_apple_developer_ac on 6/15/24.
//

import SwiftUI

struct MaxLengthModifier: ViewModifier {
    @Binding var text: String
    let maxLength: Int

    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .onChange(of: text) { oldValue, newValue in
                    if newValue.count > maxLength {
                        text = oldValue
                    }
                }
        }
    }
}

extension TextEditor {
    func maxLength(text: Binding<String>, _ maxLength: Int) -> some View {
        return ModifiedContent(content: self,
                modifier: MaxLengthModifier(text: text,maxLength: maxLength))
    }
}
