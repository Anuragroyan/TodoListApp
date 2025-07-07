//
//  DashbboardView.swift
//  TodoList
//
//  Created by Dungeon_master on 29/06/25.
//

import SwiftUI
import Charts

struct DashbboardView: View {
    var todos: [Todo]
    var total: Int { todos.count }
    var completed: Int {  todos.filter { $0.isCompleted }.count }
    var pending: Int { total - completed }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("📊 Dashboard")
                .font(.largeTitle)
                .padding(.bottom)
            Text("Total Tasks: \(total)")
                .foregroundColor(.black)
            Text("Completed: \(completed)")
                .foregroundColor(.green)
                .padding(.bottom)
            Text("Pending: \(pending)")
                .foregroundColor(.red)
                .padding(.bottom)
            Chart {
                BarMark(
                    x: .value("Status","Completed"),
                    y: .value("Count", completed)
                ).foregroundStyle(Color.green)
                BarMark(
                    x: .value("Status","Pending"),
                    y: .value("Count", pending)
                ).foregroundStyle(Color.red)
            }.frame(height: 200)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 4)
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}
