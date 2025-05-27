import SwiftUI

struct AddMemberView: View {
    @ObservedObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @State private var memberName = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("家族の名前") {
                    TextField("名前を入力", text: $memberName)
                }
            }
            .navigationTitle("家族を追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("追加") {
                        let member = FamilyMember(
                            name: memberName,
                            iconName: "person.crop.circle.fill",
                            color: ColorData(.blue)
                        )
                        dataManager.familyMembers.append(member)
                        dataManager.saveData()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(memberName.isEmpty)
                }
            }
        }
    }
} 