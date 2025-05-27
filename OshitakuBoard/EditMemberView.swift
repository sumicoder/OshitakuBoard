import SwiftUI

struct EditMemberView: View {
    @Binding var member: FamilyMember
    let onSave: () -> Void
    let onCancel: () -> Void
    @State private var name: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("名前") {
                    TextField("名前", text: $name)
                }
            }
            .navigationTitle("家族を編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル", action: onCancel)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        member.name = name
                        onSave()
                    }
                }
            }
        }
        .onAppear { name = member.name }
    }
} 