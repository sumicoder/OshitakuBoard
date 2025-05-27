import SwiftUI

struct EditingTask: Identifiable, Equatable {
    let tabIndex: Int
    let taskIndex: Int
    var id: String { "\(tabIndex)-\(taskIndex)" }
}

// MARK: - Main Content View
struct ContentView: View {
    @StateObject private var dataManager = DataManager()
    @State private var selectedFamilyIndex = 0
    @State private var selectedRoutine: String = "あさ"
    @State private var showingAddTask = false
    @State private var editingTask: Task? = nil
    @State private var showingAddFamily = false
    @State private var editingFamily: FamilyMember? = nil
    @State private var showFamilyActionSheet = false
    @State private var familyActionIndex: Int? = nil
    @State private var isSettingsOpen = false
    @AppStorage("taskColumnCount") private var taskColumnCount: Int = 2

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { isSettingsOpen.toggle() }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2)
                        .padding(8)
                        .background(Color.accentColor.opacity(0.15))
                        .clipShape(Circle())
                }
                .padding(.leading)
                Text("お支度ボード")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading, 4)
                Spacer()
            }
            .padding(.top, 8)

            // 家族一覧（カラム表示）
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                ForEach(Array(dataManager.familyMembers.enumerated()), id: \ .element.id) { (idx, member) in
                    Button(action: { selectedFamilyIndex = idx }) {
                        FamilyMemberCard(
                            member: member,
                            isSelected: selectedFamilyIndex == idx,
                            onEdit: {},
                            onDelete: {}
                        )
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 4)

            // ルーティン切り替え
            if let member = dataManager.familyMembers[safe: selectedFamilyIndex] {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(member.routines) { routine in
                            Button(action: { selectedRoutine = routine.name }) {
                                Text(routine.name)
                                    .font(.headline)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(selectedRoutine == routine.name ? Color.accentColor.opacity(0.2) : Color(.systemGray5))
                                    .cornerRadius(12)
                                    .foregroundColor(selectedRoutine == routine.name ? .accentColor : .primary)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
            }

            // 進捗バー
            if let routine = currentRoutine {
                ProgressBar(progress: routineProgress)
                    .padding(.horizontal)
            }

            // タスク一覧
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: taskColumnCount), spacing: 20) {
                    ForEach(currentTasks) { task in
                        TaskCard(
                            task: task,
                            onToggle: { toggleTask(task) }
                        )
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
        .disabled(isSettingsOpen)
        .blur(radius: isSettingsOpen ? 3 : 0)
        .fullScreenCover(isPresented: $isSettingsOpen) {
            SettingsModalView(
                isOpen: $isSettingsOpen,
                dataManager: dataManager,
                selectedFamilyIndex: $selectedFamilyIndex,
                selectedRoutine: $selectedRoutine,
                taskColumnCount: $taskColumnCount
            )
        }
        .sheet(isPresented: $showingAddTask) {
            AddEditTaskView(
                onSave: { newTask in addTask(newTask) }
            )
        }
        .sheet(item: $editingTask) { task in
            AddEditTaskView(
                task: task,
                onSave: { updatedTask in updateTask(updatedTask) }
            )
        }
        .sheet(isPresented: $showingAddFamily) {
            AddEditFamilyView(
                onSave: { newMember in
                    dataManager.addFamily(newMember)
                    showingAddFamily = false
                }
            )
        }
        .sheet(item: $editingFamily) { member in
            AddEditFamilyView(
                member: member,
                onSave: { updated in
                    dataManager.updateFamily(updated)
                    editingFamily = nil
                }
            )
        }
        .actionSheet(isPresented: $showFamilyActionSheet) {
            ActionSheet(
                title: Text("家族管理"),
                buttons: [
                    .default(Text("編集")) {
                        if let idx = familyActionIndex {
                            editingFamily = dataManager.familyMembers[idx]
                        }
                    },
                    .destructive(Text("削除")) {
                        if let idx = familyActionIndex {
                            let id = dataManager.familyMembers[idx].id
                            dataManager.deleteFamily(id: id)
                            if selectedFamilyIndex >= dataManager.familyMembers.count {
                                selectedFamilyIndex = max(0, dataManager.familyMembers.count - 1)
                            }
                        }
                    },
                    .cancel()
                ]
            )
        }
    }

    // ヘルパー
    var currentMember: FamilyMember? {
        dataManager.familyMembers[safe: selectedFamilyIndex]
    }
    var currentRoutine: Routine? {
        currentMember?.routines.first(where: { $0.name == selectedRoutine })
    }
    var currentTasks: [Task] {
        currentRoutine?.tasks ?? []
    }
    var routineProgress: Double {
        let tasks = currentTasks
        guard !tasks.isEmpty else { return 0 }
        let completed = tasks.filter { $0.isCompleted }.count
        return Double(completed) / Double(tasks.count)
    }
    func toggleTask(_ task: Task) {
        dataManager.toggleTask(for: selectedFamilyIndex, routine: selectedRoutine, taskID: task.id)
        if let memberIndex = dataManager.familyMembers.firstIndex(where: { $0.id == currentMember?.id }) {
            dataManager.familyMembers[memberIndex].experience += 1
            let exp = dataManager.familyMembers[memberIndex].experience
            let newLevel = (exp / 10) + 1
            if newLevel > dataManager.familyMembers[memberIndex].level {
                dataManager.familyMembers[memberIndex].level = newLevel
            }
            dataManager.saveData()
        }
    }
    func addTask(_ task: Task) {
        dataManager.addTask(for: selectedFamilyIndex, routine: selectedRoutine, task: task)
    }
    func updateTask(_ task: Task) {
        dataManager.updateTask(for: selectedFamilyIndex, routine: selectedRoutine, task: task)
    }
}
