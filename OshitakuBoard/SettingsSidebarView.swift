import SwiftUI

struct SettingsModalView: View {
    @Binding var isOpen: Bool
    @ObservedObject var dataManager: DataManager
    @Binding var selectedFamilyIndex: Int
    @Binding var selectedRoutine: String
    @Binding var taskColumnCount: Int
    @State private var showingAddFamily = false
    @State private var showingEditFamily = false
    @State private var showingAddRoutine = false
    @State private var showingAddTask = false
    @State private var editingTask: Task? = nil
    @State private var editingRoutine: String? = nil
    @State private var editingFamily: FamilyMember? = nil
    @State private var selectedSidebarFamilyIndex: Int = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 家族一覧
                    Text("家族一覧")
                        .font(.headline)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                        ForEach(Array(dataManager.familyMembers.enumerated()), id: \ .element.id) { (idx, member) in
                            Button(action: { selectedSidebarFamilyIndex = idx }) {
                                VStack {
                                    Image(systemName: member.iconName)
                                        .resizable()
                                        .frame(width: 64, height: 64)
                                        .foregroundColor(member.color.color)
                                        .padding(8)
                                        .background(selectedSidebarFamilyIndex == idx ? member.color.color.opacity(0.2) : Color(.systemGray5))
                                        .clipShape(Circle())
                                    Text(member.name)
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .foregroundColor(selectedSidebarFamilyIndex == idx ? .accentColor : .primary)
                                }
                            }
                            .contextMenu {
                                Button("編集") { editingFamily = member; showingEditFamily = true }
                                Button("削除", role: .destructive) {
                                    dataManager.deleteFamily(id: member.id)
                                    if selectedSidebarFamilyIndex >= dataManager.familyMembers.count {
                                        selectedSidebarFamilyIndex = max(0, dataManager.familyMembers.count - 1)
                                    }
                                }
                            }
                        }
                        Button(action: { showingAddFamily = true }) {
                            VStack {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 64, height: 64)
                                    .padding(8)
                                    .background(Color(.systemGray5))
                                    .clipShape(Circle())
                                Text("追加")
                                    .font(.title3)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    Divider()
                    // ルーティン一覧
                    if let member = dataManager.familyMembers[safe: selectedSidebarFamilyIndex] {
                        Text("ルーティン一覧")
                            .font(.headline)
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack(alignment: .top, spacing: 16) {
                                ForEach(member.routines) { routine in
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text(routine.name)
                                                .font(.title3)
                                                .fontWeight(.bold)
                                            Button(action: {
                                                editingRoutine = routine.name
                                                // ルーティン編集UIを出す場合はここで
                                            }) {
                                                Image(systemName: "pencil")
                                                    .font(.title3)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            Button(action: {
                                                // ルーティン削除
                                                if let idx = member.routines.firstIndex(where: { $0.id == routine.id }) {
                                                    dataManager.familyMembers[selectedSidebarFamilyIndex].routines.remove(at: idx)
                                                    dataManager.saveData()
                                                }
                                            }) {
                                                Image(systemName: "trash")
                                                    .font(.title3)
                                                    .foregroundColor(.red)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                        // タスク一覧
                                        ForEach(routine.tasks) { task in
                                            HStack(spacing: 12) {
                                                Image(systemName: task.iconName)
                                                    .resizable()
                                                    .frame(width: 32, height: 32)
                                                    .foregroundColor(task.color.color)
                                                Text(task.name)
                                                    .font(.title3)
                                                    .fontWeight(.medium)
                                                Spacer()
                                                Button(action: { editingTask = task }) {
                                                    Image(systemName: "pencil")
                                                        .font(.title3)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                                Button(action: {
                                                    // タスク削除
                                                    if let ridx = member.routines.firstIndex(where: { $0.id == routine.id }),
                                                       let tidx = member.routines[ridx].tasks.firstIndex(where: { $0.id == task.id }) {
                                                        dataManager.familyMembers[selectedSidebarFamilyIndex].routines[ridx].tasks.remove(at: tidx)
                                                        dataManager.saveData()
                                                    }
                                                }) {
                                                    Image(systemName: "trash")
                                                        .font(.title3)
                                                        .foregroundColor(.red)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                            .padding(.vertical, 6)
                                        }
                                        Button(action: {
                                            showingAddTask = true
                                            editingRoutine = routine.name
                                        }) {
                                            Label("タスク追加", systemImage: "plus")
                                                .font(.title3)
                                        }
                                    }
                                    .padding(8)
                                    .background(Color(.systemGray5))
                                    .cornerRadius(12)
                                }
                                if member.routines.count < 5 {
                                    Button(action: { showingAddRoutine = true }) {
                                        VStack {
                                            Image(systemName: "plus")
                                                .resizable()
                                                .frame(width: 32, height: 32)
                                                .padding(8)
                                                .background(Color(.systemGray5))
                                                .clipShape(Circle())
                                            Text("追加")
                                                .font(.title3)
                                        }
                                    }
                                } else {
                                    Text("最大5つまで追加できます")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 8)
                                }
                            }
                        }
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 8) {
                        Text("タスク表示カラム数")
                        Stepper(value: $taskColumnCount, in: 1...4) {
                            Text("\(taskColumnCount)カラム")
                        }
                    }
                    Spacer(minLength: 40)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("閉じる") { isOpen = false }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color(.systemGray6))
        .zIndex(1)
        .sheet(isPresented: $showingAddFamily) {
            AddEditFamilyView { newMember in
                dataManager.addFamily(newMember)
                showingAddFamily = false
            }
        }
        .sheet(isPresented: $showingEditFamily) {
            if let member = editingFamily {
                AddEditFamilyView(member: member) { updated in
                    dataManager.updateFamily(updated)
                    showingEditFamily = false
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddEditTaskView { newTask in
                if let member = dataManager.familyMembers[safe: selectedSidebarFamilyIndex] {
                    dataManager.addTask(for: selectedSidebarFamilyIndex, routine: selectedRoutine, task: newTask)
                }
                showingAddTask = false
            }
        }
        .sheet(isPresented: $showingAddRoutine) {
            AddRoutineNameView { routineName in
                if let member = dataManager.familyMembers[safe: selectedSidebarFamilyIndex],
                   !member.routines.contains(where: { $0.name == routineName }),
                   !routineName.isEmpty,
                   member.routines.count < 5 {
                    dataManager.familyMembers[selectedSidebarFamilyIndex].routines.append(Routine(name: routineName, tasks: []))
                    dataManager.saveData()
                }
                showingAddRoutine = false
            }
        }
        .sheet(item: $editingTask) { task in
            AddEditTaskView(task: task) { updated in
                if let member = dataManager.familyMembers[safe: selectedSidebarFamilyIndex],
                   let ridx = member.routines.firstIndex(where: { $0.name == selectedRoutine }),
                   let tidx = member.routines[ridx].tasks.firstIndex(where: { $0.id == task.id }) {
                    dataManager.familyMembers[selectedSidebarFamilyIndex].routines[ridx].tasks[tidx] = updated
                    dataManager.saveData()
                }
                editingTask = nil
            }
        }
    }
}

// 新しいルーティン名入力用View
struct AddRoutineNameView: View {
    let onAdd: (String) -> Void
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    var body: some View {
        NavigationView {
            Form {
                Section("ルーティン名") {
                    TextField("例: ばん", text: $name)
                }
            }
            .navigationTitle("ルーティン追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") { presentationMode.wrappedValue.dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("追加") {
                        onAdd(name.trimmingCharacters(in: .whitespacesAndNewlines))
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
} 