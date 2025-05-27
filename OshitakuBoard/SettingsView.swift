import SwiftUI

struct SettingsView: View {
    @ObservedObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section("アプリ情報") {
                    Text("お支度ボードアプリ")
                    Text("バージョン 1.0")
                }
                
                Section("データ") {
                    Button("データをリセット") {
                        dataManager.resetData()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完了") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
} 