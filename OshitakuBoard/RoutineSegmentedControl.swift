import SwiftUI

struct RoutineSegmentedControl: View {
    @Binding var selected: String
    var routineNames: [String]
    var body: some View {
        Picker("ルーティン", selection: $selected) {
            ForEach(routineNames, id: \.self) { name in
                Text(name)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
} 