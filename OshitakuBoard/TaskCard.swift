import SwiftUI

struct TaskCard: View {
    let task: Task
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            VStack(spacing: 16) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 56, height: 56)
                            .overlay(
                                Circle()
                                    .stroke(task.color.color, lineWidth: 3)
                            )
                        Image(systemName: task.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundColor(task.color.color)
                    }
                    Spacer()
                }
                Text(task.name)
                    .font(.title3)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                Spacer(minLength: 0)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(task.isCompleted ? task.color.color : Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color(.black).opacity(0.05), radius: 4, x: 0, y: 2)
            .animation(.spring(), value: task.isCompleted)
        }
        .buttonStyle(PlainButtonStyle())
    }
} 