//
//  Todo.swift
//  TodoList
//
//  Created by Dungeon_master on 29/06/25.
//

import Foundation
import FirebaseFirestoreSwift

struct Todo: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var updatedAt: Date?
    var iconName: String? = nil 
}
