import SwiftUI

struct TaskMenuView: View {
    @Binding var member: FamilyMember
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedRoutineIndex = 0
    @State private var showingAddTask = false
    @State private var showingAddRoutine = false
    @State private var newRoutineName = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // ルーティンセレクタ
                Picker("ルーティン", selection: $selectedRoutineIndex) {
                    ForEach(0..<member.routines.count, id: \.self) { index in
                        Text(member.routines[index].name).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // タスクリスト
                List {
                    ForEach(member.routines[selectedRoutineIndex].tasks.indices, id: \.self) { index in
                        TaskRowView(task: $member.routines[selectedRoutineIndex].tasks[index])
                    }
                    .onDelete { offsets in
                        member.routines[selectedRoutineIndex].tasks.remove(atOffsets: offsets)
                    }
                }
                
                Spacer()
                Button("ルーティン追加") { showingAddRoutine = true }
            }
            .navigationTitle("タスク管理")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("タスク追加") {
                        showingAddTask = true
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("完了") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView { task in
                member.routines[selectedRoutineIndex].tasks.append(task)
            }
        }
        .sheet(isPresented: $showingAddRoutine) {
            NavigationView {
                Form {
                    Section("ルーティン名") {
                        TextField("新しいルーティン名", text: $newRoutineName)
                    }
                    Button("追加") {
                        if !newRoutineName.isEmpty && !member.routines.contains(where: { $0.name == newRoutineName }) {
                            member.routines.append(Routine(name: newRoutineName, tasks: []))
                        }
                        showingAddRoutine = false
                        newRoutineName = ""
                    }
                    .disabled(newRoutineName.isEmpty)
                }
                .navigationTitle("ルーティン追加")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("キャンセル") { showingAddRoutine = false }
                    }
                }
            }
        }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        member.routines[selectedRoutineIndex].tasks.remove(atOffsets: offsets)
    }
}

struct TaskRowView: View {
    @Binding var task: Task
    
    var body: some View {
        HStack {
            Circle()
                .fill(task.color.color)
                .frame(width: 20, height: 20)
            
            Text(task.name)
            
            Spacer()
            
            Toggle("完了", isOn: $task.isCompleted)
                .labelsHidden()
        }
    }
} 