import SwiftUI

struct MemberView: View {
    @Binding var member: FamilyMember
    @ObservedObject var dataManager: DataManager
    @State private var selectedRoutineName: String = "あさ"
    @State private var showingTaskMenu = false
    @State private var showingCelebration = false
    @State private var showClock = true
    
    var body: some View {
        VStack(spacing: 20) {
            // Member Info and Clock
            HStack {
                VStack(alignment: .leading) {
                    Text(member.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("レベル \(member.level)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("経験値: \(member.experience)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                if showClock {
                    ClockView(tasks: visibleTasks)
                        .frame(width: 80, height: 80)
                }
            }
            .padding(.horizontal)
            
            // Start Button
            Button("1日のスタート") {
                startNewDay()
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            
            // Routine Tabs
            if !member.routines.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(member.routines) { routine in
                            Button(action: { selectedRoutineName = routine.name }) {
                                Text(routine.name)
                                    .font(.headline)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(selectedRoutineName == routine.name ? Color.accentColor.opacity(0.2) : Color(.systemGray5))
                                    .cornerRadius(12)
                                    .foregroundColor(selectedRoutineName == routine.name ? .accentColor : .primary)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
            }
            
            Spacer()
        }
        .overlay(
            // Side Menu Button
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        showingTaskMenu = true
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding()
            }
        )
        .sheet(isPresented: $showingTaskMenu) {
            TaskMenuView(member: $member)
        }
        .alert("おめでとう！", isPresented: $showingCelebration) {
            Button("OK") { }
        } message: {
            Text("レベルアップしました！")
        }
    }
    
    private var visibleTasks: [Task] {
        guard let routine = member.routines.first(where: { $0.name == selectedRoutineName }) else { return [] }
        return routine.tasks
    }
    
    private func startNewDay() {
        for routineIndex in member.routines.indices {
            for taskIndex in member.routines[routineIndex].tasks.indices {
                member.routines[routineIndex].tasks[taskIndex].isCompleted = false
            }
        }
        dataManager.saveData()
    }
    
    private func completeTask(_ task: Task) {
        member.experience += 1
        let newLevel = (member.experience / 10) + 1
        if newLevel > member.level {
            member.level = newLevel
            showingCelebration = true
        }
        dataManager.saveData()
    }
}

struct RoutineTabView: View {
    @Binding var routine: Routine
    let onTaskComplete: (Task) -> Void
    @State private var currentTaskIndex = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text(routine.name)
                .font(.title)
                .fontWeight(.bold)
            
            if !routine.tasks.isEmpty {
                TabView(selection: $currentTaskIndex) {
                    ForEach(0..<routine.tasks.count, id: \.self) { index in
                        TaskView(
                            task: $routine.tasks[index],
                            onComplete: onTaskComplete
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            } else {
                Text("タスクがありません")
                    .foregroundColor(.secondary)
                    .font(.title2)
            }
        }
        .padding()
    }
}

struct TaskView: View {
    @Binding var task: Task
    let onComplete: (Task) -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text(task.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Button(action: {
                task.isCompleted.toggle()
                if task.isCompleted {
                    onComplete(task)
                }
            }) {
                Circle()
                    .fill(task.isCompleted ? task.color.color : Color.gray.opacity(0.3))
                    .frame(width: 150, height: 150)
                    .overlay(
                        Image(systemName: task.isCompleted ? "checkmark" : "circle")
                            .font(.system(size: 50))
                            .foregroundColor(task.isCompleted ? .white : .gray)
                    )
            }
        }
        .padding()
    }
}

struct ClockView: View {
    let tasks: [Task]
    @State private var currentTime = Date()
    
    var body: some View {
        ZStack {
            Circle()
                .fill(clockColor)
                .overlay(
                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                )
            
            // Clock face
            ForEach(1...12, id: \.self) { hour in
                Text("\(hour)")
                    .font(.caption2)
                    .position(
                        x: 40 + 25 * cos(Double(hour - 3) * .pi / 6),
                        y: 40 + 25 * sin(Double(hour - 3) * .pi / 6)
                    )
            }
            
            // Clock hands
            ClockHands(time: currentTime)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                currentTime = Date()
            }
        }
    }
    
    private var clockColor: Color {
        let completedTasks = tasks.filter { $0.isCompleted }
        if let firstCompleted = completedTasks.first {
            return firstCompleted.color.color.opacity(0.3)
        }
        return Color.white
    }
}

struct ClockHands: View {
    let time: Date
    
    var body: some View {
        ZStack {
            // Hour hand
            Rectangle()
                .fill(Color.black)
                .frame(width: 2, height: 15)
                .offset(y: -7.5)
                .rotationEffect(.degrees(hourAngle))
            
            // Minute hand
            Rectangle()
                .fill(Color.black)
                .frame(width: 1, height: 20)
                .offset(y: -10)
                .rotationEffect(.degrees(minuteAngle))
            
            // Center dot
            Circle()
                .fill(Color.black)
                .frame(width: 4, height: 4)
        }
    }
    
    private var hourAngle: Double {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        return Double(hour % 12) * 30 + Double(minute) * 0.5
    }
    
    private var minuteAngle: Double {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: time)
        return Double(minute) * 6
    }
} 