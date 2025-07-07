//
//  EditTodoView.swift
//  TodoList
//
//  Created by Dungeon_master on 29/06/25.
//

import SwiftUI

struct EditTodoView: View {
    var todo: Todo
    @Binding var newTitle: String
    @Binding var iconName: String
    var onSave: (String, String) -> Void
    @Environment(\.dismiss) var dismiss

    let availableIcons = ["pencil", "star", "flag", "bell", "bookmark", "calendar"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Task")) {
                    TextField("Title", text: $newTitle)
                }

                Section(header: Text("Icon")) {
                    Picker("Icon", selection: $iconName) {
                        ForEach(availableIcons, id: \.self) { icon in
                            Label(icon.capitalized, systemImage: icon)
                                .tag(icon)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("Edit Todo")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let trimmedTitle = newTitle.trimmingCharacters(in: .whitespaces)
                        if !trimmedTitle.isEmpty {
                            onSave(trimmedTitle, iconName)
                            dismiss()
                        }
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
