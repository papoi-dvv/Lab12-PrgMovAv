//
//  Profesor.swift
//  LabS12-Santos
//
//  Created by Tecsup on 1/06/26.
//

import Foundation
import SwiftData

@Model
class Profesor {
    @Attribute(.unique) var idProfesor: UUID
    var apellido: String
    var apellidoM: String
    var nombre: String
    var email: String
    var telefono: String
    var fechaNacimiento: Date
    var profesion: String
    var contratacion: Date
    
    var estadoRaw: String
    var facultadRaw: String
    
    var estado: Estado {
        get { Estado(rawValue: estadoRaw) ?? .activo }
        set { estadoRaw = newValue.rawValue }
    }
    
    var facultad: Facultad {
        get { Facultad(rawValue: facultadRaw) ?? .tecnologia }
        set { facultadRaw = newValue.rawValue }
    }
    
    init(
        idProfesor: UUID = UUID(),
        apellido: String,
        apellidoM: String,
        nombre: String,
        email: String,
        telefono: String,
        fechaNacimiento: Date,
        profesion: String,
        contratacion: Date,
        estado: Estado = .activo,
        facultad: Facultad = .tecnologia
    ) {
        self.idProfesor = idProfesor
        self.apellido = apellido
        self.apellidoM = apellidoM
        self.nombre = nombre
        self.email = email
        self.telefono = telefono
        self.fechaNacimiento = fechaNacimiento
        self.profesion = profesion
        self.contratacion = contratacion
        self.estadoRaw = estado.rawValue
        self.facultadRaw = facultad.rawValue
    }
    
    enum Estado: String, CaseIterable, Identifiable {
        case activo = "Activo"
        case inactivo = "Inactivo"

        var id: String { rawValue }
    }

    enum Facultad: String, CaseIterable, Identifiable {
        case tecnologia = "Tecnología"
        case arquitectura = "Arquitectura"
        case medicina = "Medicina"
        case humanidades = "Humanidades"
        case cienciaExactas = "Ciencia Exactas"
        case derecho = "Derecho"
        case ingenieria = "Ingeniería"
        
        var id: String { rawValue }
    }
}
