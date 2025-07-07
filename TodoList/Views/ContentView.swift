import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TodoViewModel()
    @State private var newTitle = ""
    @State private var selectedIcon = "pencil"
    @State private var searchText = ""
    @State private var selectedTodo: Todo?
    @State private var editedTitle: String = ""
    @State private var editedIconName: String = "pencil"
    @State private var showingEditSheet = false
    @State private var recentlyDeleted: Todo?

    let availableIcons = ["pencil", "star", "flag", "bell", "bookmark", "calendar"]

    var filteredTodos: [Todo] {
        if searchText.isEmpty {
            return viewModel.todos
        } else {
            return viewModel.todos.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Add Task Field
                HStack {
                    Menu {
                        ForEach(availableIcons, id: \.self) { icon in
                            Button {
                                selectedIcon = icon
                            } label: {
                                Label(icon.capitalized, systemImage: icon)
                            }
                        }
                    } label: {
                        Image(systemName: selectedIcon)
                            .font(.title2)
                            .frame(width: 36, height: 36)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }

                    TextField("New Task", text: $newTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)

                    Button(action: {
                        guard !newTitle.isEmpty else { return }
                        let title = newTitle
                        let icon = selectedIcon
                        newTitle = ""

                        viewModel.addTodo(title: title, iconName: icon) { newTodo in
                            selectedTodo = newTodo
                            editedTitle = newTodo.title
                            editedIconName = newTodo.iconName ?? "pencil"
                            showingEditSheet = true
                        }
                    }) {
                        Text("Add")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()

                // Task List with Swipe-to-Delete
                List {
                    Section(header: Text("Incomplete")) {
                        ForEach(filteredTodos.filter { !$0.isCompleted }) { todo in
                            taskRow(todo: todo)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        recentlyDeleted = todo
                                        viewModel.deleteTodo(todo: todo)

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                            if recentlyDeleted?.id == todo.id {
                                                recentlyDeleted = nil
                                            }
                                        }
                                    } label: {
                                        Label("Trash", systemImage: "trash")
                                    }
                                }
                        }
                    }

                    Section(header: Text("Completed")) {
                        ForEach(filteredTodos.filter { $0.isCompleted }) { todo in
                            taskRow(todo: todo)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        recentlyDeleted = todo
                                        viewModel.deleteTodo(todo: todo)

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                            if recentlyDeleted?.id == todo.id {
                                                recentlyDeleted = nil
                                            }
                                        }
                                    } label: {
                                        Label("Trash", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())

                // Undo Delete Button
                if let deleted = recentlyDeleted {
                    Button("Undo Delete") {
                        viewModel.undoDelete(todo: deleted)
                        recentlyDeleted = nil
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                // Dashboard Navigation
                NavigationLink("Dashboard", destination: DashbboardView(todos: viewModel.todos))
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationTitle("📝 To-Do List")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .sheet(isPresented: $showingEditSheet) {
                EditTodoSheetWrapper(
                    selectedTodo: $selectedTodo,
                    editedTitle: $editedTitle,
                    editedIconName: $editedIconName
                ) { newTitle, newIcon in
                    if let todo = selectedTodo {
                        viewModel.updateTodoTitleAndIcon(todo: todo, newTitle: newTitle, iconName: newIcon)
                    }
                }
            }
        }
    }

    func taskRow(todo: Todo) -> some View {
        HStack {
            Image(systemName: todo.iconName ?? "pencil")
                .foregroundColor(.blue)

            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(todo.isCompleted ? .green : .gray)
                .onTapGesture {
                    viewModel.toggleCompletion(todo: todo)
                }

            Text(todo.title)
                .strikethrough(todo.isCompleted)
                .foregroundColor(todo.isCompleted ? .gray : .black)
                .onTapGesture {
                    selectedTodo = todo
                    editedTitle = todo.title
                    editedIconName = todo.iconName ?? "pencil"
                    showingEditSheet = true
                }
        }
        .padding(6)
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(8)
    }
}

