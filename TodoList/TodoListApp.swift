//
//  TodoListApp.swift
//  TodoList
//
//  Created by Dungeon_master on 29/06/25.
//

import SwiftUI
import Firebase


@main
struct TodoListApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
