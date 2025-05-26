//
//  OshitakuBoardApp.swift
//  OshitakuBoard
//
//  Created by Tsuru on 2025/05/26.
//

import SwiftUI

@main
struct OshitakuBoardApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
