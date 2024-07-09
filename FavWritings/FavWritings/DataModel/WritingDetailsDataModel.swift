//
//  WritingDetailsDataModel.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 9/7/24.
//

import Foundation
import SwiftData

@Model
final class WritingDetailsDataModel: Identifiable {

    @Attribute(.unique) var id: String = UUID().uuidString
    var name: String
    var writer: String
    var content: String
    var type: String
    var language: String
    
    init(
        id: String,
        name: String, 
        writer: String,
        content: String,
        type: String,
        language: String
    ) {
        self.id = id
        self.name = name
        self.writer = writer
        self.content = content
        self.type = type
        self.language = language
    }
}
