//
//  EditTodoSheetWrapper.swift
//  TodoList
//
//  Created by Dungeon_master on 29/06/25.
//
import SwiftUI

struct EditTodoSheetWrapper: View {
    @Binding var selectedTodo: Todo?
    @Binding var editedTitle: String
    @Binding var editedIconName: String
    var onSave: (String, String) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Group {
            if let todo = selectedTodo {
                EditTodoView(
                    todo: todo,
                    newTitle: $editedTitle,
                    iconName: $editedIconName
                ) { newTitle, newIcon in
                    onSave(newTitle, newIcon)
                    dismiss()
                }
            } else {
                VStack {
                    Text("No task selected.")
                        .foregroundColor(.gray)
                        .padding()
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
    }
}
