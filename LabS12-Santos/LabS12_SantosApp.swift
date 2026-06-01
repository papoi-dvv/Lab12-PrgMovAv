//
//  LabS12_SantosApp.swift
//  LabS12-Santos
//
//  Created by Tecsup on 1/06/26.
//

import SwiftUI
import SwiftData

@main
struct LabS12_SantosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(ModelContainerProvider.shared.container)
        }
    }
}
