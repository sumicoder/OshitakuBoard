import SwiftUI

struct AddEditTaskView: View {
    var task: Task? = nil
    var onSave: (Task) -> Void
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var iconName: String = "checkmark.circle.fill"
    @State private var color: Color = .blue
    let iconOptions = [
        "sun.max.fill", "drop.fill", "face.smiling", "tshirt.fill", "fork.knife", "scissors", "bag.fill", "gamecontroller.fill", "house.fill", "hands.sparkles.fill", "book.fill", "cube.box.fill", "mouth.fill", "toilet.fill", "moon.fill"
    ]
    var body: some View {
        NavigationView {
            Form {
                Section("タスク名") {
                    TextField("タスク名", text: $name)
                }
                Section("アイコン") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(iconOptions, id: \.self) { icon in
                                Button(action: { iconName = icon }) {
                                    Image(systemName: icon)
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                        .padding(6)
                                        .background(iconName == icon ? color.opacity(0.2) : Color(.systemGray5))
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                }
                Section("色") {
                    ColorPicker("色を選ぶ", selection: $color)
                }
            }
            .navigationTitle(task == nil ? "タスク追加" : "タスク編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") { presentationMode.wrappedValue.dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        let newTask = Task(
                            id: task?.id ?? UUID(),
                            name: name,
                            iconName: iconName,
                            color: ColorData(color),
                            isCompleted: task?.isCompleted ?? false
                        )
                        onSave(newTask)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
        .onAppear {
            if let task = task {
                name = task.name
                iconName = task.iconName
                color = task.color.color
            }
        }
    }
} 