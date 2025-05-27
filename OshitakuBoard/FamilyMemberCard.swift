import SwiftUI

struct FamilyMemberCard: View {
    let member: FamilyMember
    let isSelected: Bool
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: member.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 224, height: 56)
                .foregroundColor(member.color.color)
                .padding(4)
                .background(isSelected ? member.color.color.opacity(0.15) : Color(.systemGray5))
                .clipShape(Circle())
            HStack {
                Text(member.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(isSelected ? .blue : .primary)
                Spacer()
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .foregroundColor(.gray)
                }
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal, 8)
            HStack {
                Text("Lv.\(member.level)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("経験値: \(member.experience)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .frame(width: 224, height: 120)
        .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
} 