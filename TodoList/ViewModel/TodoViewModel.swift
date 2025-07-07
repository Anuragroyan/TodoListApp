//
//  TodoViewModel.swift
//  TodoList
//
//  Created by Dungeon_master on 29/06/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    private var db = Firestore.firestore()

    init() {
        fetchTodos()
    }

    func fetchTodos() {
        db.collection("todos")
            .order(by: "createdAt", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self.todos = documents.compactMap { try? $0.data(as: Todo.self) }
            }
    }

    /// Adds a new todo and returns it via completion handler
    func addTodo(title: String, iconName: String?, completion: @escaping (Todo) -> Void) {
        let newTodo = Todo(title: title, isCompleted: false, createdAt: Date(), iconName: iconName)
        do {
            let ref = try db.collection("todos").addDocument(from: newTodo)
            var todoWithID = newTodo
            todoWithID.id = ref.documentID
            completion(todoWithID)
        } catch {
            print("Error adding todo: \(error)")
        }
    }

    /// Toggle completion and update timestamp
    func toggleCompletion(todo: Todo) {
        guard let id = todo.id else { return }
        db.collection("todos").document(id).updateData([
            "isCompleted": !todo.isCompleted,
            "updatedAt": Date()
        ])
    }

    /// Permanently delete a todo
    func deleteTodo(todo: Todo) {
        guard let id = todo.id else { return }
        db.collection("todos").document(id).delete()
    }

    /// Restore a previously deleted todo with updated timestamp
    func undoDelete(todo: Todo) {
        var restoredTodo = todo
        restoredTodo.updatedAt = Date()

        do {
            _ = try db.collection("todos").addDocument(from: restoredTodo)
        } catch {
            print("Error restoring todo: \(error)")
        }
    }

    /// Update title and update timestamp
    func updateTodoTitle(todo: Todo, newTitle: String) {
        guard let id = todo.id else { return }
        db.collection("todos").document(id).updateData([
            "title": newTitle,
            "updatedAt": Date()
        ])
    }

    /// Update title and icon
    func updateTodoTitleAndIcon(todo: Todo, newTitle: String, iconName: String) {
        guard let id = todo.id else { return }
        db.collection("todos").document(id).updateData([
            "title": newTitle,
            "iconName": iconName,
            "updatedAt": Date()
        ])
    }
}
