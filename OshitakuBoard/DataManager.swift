import SwiftUI

class DataManager: ObservableObject {
    @Published var familyMembers: [FamilyMember] = []
    
    private let userDefaults = UserDefaults.standard
    private let dataKey = "FamilyMembersData"
    
    init() {
        loadData()
    }
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(familyMembers) {
            userDefaults.set(encoded, forKey: dataKey)
        }
    }
    
    func loadData() {
        if let data = userDefaults.data(forKey: dataKey),
           let decoded = try? JSONDecoder().decode([FamilyMember].self, from: data) {
            familyMembers = decoded
        }
    }
    
    func resetData() {
        familyMembers = []
        userDefaults.removeObject(forKey: dataKey)
    }
    
    // 家族追加
    func addFamily(_ member: FamilyMember) {
        familyMembers.append(member)
        saveData()
    }
    
    // 家族更新
    func updateFamily(_ member: FamilyMember) {
        if let idx = familyMembers.firstIndex(where: { $0.id == member.id }) {
            familyMembers[idx] = member
            saveData()
        }
    }
    
    // 家族削除
    func deleteFamily(id: UUID) {
        familyMembers.removeAll { $0.id == id }
        saveData()
    }
    
    // タスク追加
    func addTask(for familyIndex: Int, routine: String, task: Task) {
        guard familyMembers.indices.contains(familyIndex) else { return }
        if let routineIndex = familyMembers[familyIndex].routines.firstIndex(where: { $0.name == routine }) {
            familyMembers[familyIndex].routines[routineIndex].tasks.append(task)
            saveData()
        }
    }
    
    // タスク更新
    func updateTask(for familyIndex: Int, routine: String, task: Task) {
        guard familyMembers.indices.contains(familyIndex) else { return }
        if let routineIndex = familyMembers[familyIndex].routines.firstIndex(where: { $0.name == routine }) {
            if let taskIndex = familyMembers[familyIndex].routines[routineIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                familyMembers[familyIndex].routines[routineIndex].tasks[taskIndex] = task
                saveData()
            }
        }
    }
    
    // タスク完了トグル
    func toggleTask(for familyIndex: Int, routine: String, taskID: UUID) {
        guard familyMembers.indices.contains(familyIndex) else { return }
        if let routineIndex = familyMembers[familyIndex].routines.firstIndex(where: { $0.name == routine }) {
            if let taskIndex = familyMembers[familyIndex].routines[routineIndex].tasks.firstIndex(where: { $0.id == taskID }) {
                familyMembers[familyIndex].routines[routineIndex].tasks[taskIndex].isCompleted.toggle()
                saveData()
            }
        }
    }
} 