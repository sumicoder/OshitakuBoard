import SwiftUI

struct FamilyTabBar: View {
    @Binding var members: [FamilyMember]
    @Binding var selectedIndex: Int
    var onLongPress: ((Int) -> Void)? = nil
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(Array(members.enumerated()), id: \.element.id) { (index, member) in
                    Button(action: { selectedIndex = index }) {
                        VStack(spacing: 4) {
                            Image(systemName: member.iconName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(member.color.color)
                                .padding(8)
                                .background(selectedIndex == index ? member.color.color.opacity(0.2) : Color(.systemGray6))
                                .clipShape(Circle())
                            Text(member.name)
                                .font(.caption)
                                .foregroundColor(selectedIndex == index ? .accentColor : .primary)
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(selectedIndex == index ? Color.accentColor.opacity(0.1) : Color.clear)
                        .cornerRadius(12)
                    }
                    .simultaneousGesture(LongPressGesture().onEnded { _ in
                        onLongPress?(index)
                    })
                    .onDrag {
                        NSItemProvider(object: String(index) as NSString)
                    }
                    .onDrop(of: [.text], delegate: FamilyDropDelegate(
                        fromIndex: index,
                        members: $members,
                        selectedIndex: $selectedIndex
                    ))
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 80)
    }
}

struct FamilyDropDelegate: DropDelegate {
    let fromIndex: Int
    @Binding var members: [FamilyMember]
    @Binding var selectedIndex: Int

    func performDrop(info: DropInfo) -> Bool {
        guard let item = info.itemProviders(for: [.text]).first else { return false }
        item.loadItem(forTypeIdentifier: "public.text", options: nil) { (data, error) in
            DispatchQueue.main.async {
                if let data = data as? Data, let str = String(data: data, encoding: .utf8), let oldIndex = Int(str) {
                    let member = members.remove(at: oldIndex)
                    members.insert(member, at: fromIndex)
                    // 選択中インデックスも更新
                    if selectedIndex == oldIndex {
                        selectedIndex = fromIndex
                    } else if selectedIndex > oldIndex && selectedIndex <= fromIndex {
                        selectedIndex -= 1
                    } else if selectedIndex < oldIndex && selectedIndex >= fromIndex {
                        selectedIndex += 1
                    }
                }
            }
        }
        return true
    }
} 