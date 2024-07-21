//
//  NewCard.swift
//  13jo
//
//  Created by Shim Hyeonhee on 6/15/24.
//

import Foundation
import SwiftData

@Model
class NewCard: Identifiable {
    var id: UUID = UUID()
    var question: String
    var answer: String
    
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
    }
}


