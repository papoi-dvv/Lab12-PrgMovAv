//
//  ModelContainerProvider.swift
//  LabS12-Santos
//
//  Created by Tecsup on 1/06/26.
//

import Foundation
import SwiftData

@MainActor
class ModelContainerProvider {
    static let shared = ModelContainerProvider()
    let container: ModelContainer
    
    private init(){
        let schema = Schema([Profesor.self])
        
        do {
            let config = ModelConfiguration(
                "ProfesoresData",
                schema: schema,
                url: FileManager.default
                    .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                    .first!
                    .appendingPathComponent("ProfesoresData.sqlite")
            )
            container = try ModelContainer(for:schema, configurations: [config])
        } catch {
            fatalError("Error al inicializar ModelContainer: \(error)")
        }
    }
}
