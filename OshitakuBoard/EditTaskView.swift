import SwiftUI

struct EditTaskView: View {
    @Binding var task: Task
    let onSave: () -> Void
    let onCancel: () -> Void
    @State private var name: String = ""
    @State private var color: Color = .blue
    
    var body: some View {
        NavigationView {
            Form {
                Section("タスク名") {
                    TextField("タスク名", text: $name)
                }
                Section("色") {
                    ColorPicker("色", selection: $color)
                }
            }
            .navigationTitle("タスクを編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル", action: onCancel)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        task.name = name
                        task.color = ColorData(color)
                        onSave()
                    }
                }
            }
        }
        .onAppear {
            name = task.name
            color = task.color.color
        }
    }
} 