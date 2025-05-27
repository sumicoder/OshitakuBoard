import SwiftUI

struct AddTaskView: View {
    let onAdd: (Task) -> Void
    @Environment(\.presentationMode) var presentationMode
    @State private var taskName = ""
    @State private var selectedColor = Color.blue
    @State private var selectedIcon = "checkmark.circle.fill"
    let iconOptions = [
        "sun.max.fill", "drop.fill", "face.smiling", "tshirt.fill", "fork.knife", "scissors", "bag.fill", "gamecontroller.fill", "house.fill", "hands.sparkles.fill", "book.fill", "cube.box.fill", "mouth.fill", "toilet.fill", "moon.fill"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section("タスク名") {
                    TextField("タスク名を入力", text: $taskName)
                }
                Section("アイコン") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(iconOptions, id: \.self) { icon in
                                Button(action: { selectedIcon = icon }) {
                                    Image(systemName: icon)
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                        .padding(6)
                                        .background(selectedIcon == icon ? selectedColor.opacity(0.2) : Color(.systemGray5))
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                }
                Section("色") {
                    ColorPicker("タスクの色", selection: $selectedColor)
                }
            }
            .navigationTitle("新しいタスク")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("追加") {
                        let task = Task(name: taskName, iconName: selectedIcon, color: ColorData(selectedColor))
                        onAdd(task)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(taskName.isEmpty)
                }
            }
        }
    }
}

struct AddTabView: View {
    let onAdd: (String) -> Void
    @Environment(\.presentationMode) var presentationMode
    @State private var tabName = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("タブ名") {
                    TextField("タブ名を入力", text: $tabName)
                }
            }
            .navigationTitle("新しいタブ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("追加") {
                        onAdd(tabName)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(tabName.isEmpty)
                }
            }
        }
    }
} 