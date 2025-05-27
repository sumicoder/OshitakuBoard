import SwiftUI

struct AddEditFamilyView: View {
    var member: FamilyMember? = nil
    var onSave: (FamilyMember) -> Void
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var iconName: String = "person.crop.circle.fill"
    @State private var color: Color = .blue
    let iconOptions = [
        "person.crop.circle.fill", "person.2.fill", "person.3.fill", "person.crop.square.filled.and.at.rectangle", "person.circle.fill", "star.fill", "heart.fill"
    ]
    var body: some View {
        NavigationView {
            Form {
                Section("名前") {
                    TextField("名前", text: $name)
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
            .navigationTitle(member == nil ? "家族追加" : "家族編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") { presentationMode.wrappedValue.dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        let newMember = FamilyMember(
                            id: member?.id ?? UUID(),
                            name: name,
                            iconName: iconName,
                            color: ColorData(color)
                        )
                        onSave(newMember)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
        .onAppear {
            if let member = member {
                name = member.name
                iconName = member.iconName
                color = member.color.color
            }
        }
    }
} 