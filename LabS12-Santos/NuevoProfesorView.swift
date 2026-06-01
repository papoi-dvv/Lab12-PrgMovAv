//
//  NuevoProfesorView.swift
//  LabS12-Santos
//
//  Created by Tecsup on 1/06/26.
//

import SwiftUI
import SwiftData

struct NuevoProfesorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var apellido = ""
    @State private var nombre = ""
    @State private var email = ""
    @State private var telefono = ""
    @State private var profesion = ""
    @State private var fechaNacimiento = Date()
    @State private var contratacion = Date()
    @State private var estado: Profesor.Estado = .activo
    @State private var facultad: Profesor.Facultad = .tecnologia

    private var formularioValido: Bool {
        !apellido.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !telefono.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !profesion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Datos Personales")) {
                    TextField("Apellido", text: $apellido)
                    TextField("Nombre", text: $nombre)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    TextField("Teléfono", text: $telefono)
                        .keyboardType(.phonePad)

                    DatePicker("Fecha de Nacimiento", selection: $fechaNacimiento, displayedComponents: .date)
                }

                Section(header: Text("Datos Académicos")) {
                    TextField("Profesión", text: $profesion)
                    DatePicker("Fecha de Contratación", selection: $contratacion, displayedComponents: .date)

                    Picker("Estado", selection: $estado) {
                        ForEach(Profesor.Estado.allCases) { estado in
                            Text(estado.rawValue).tag(estado)
                        }
                    }
                    .pickerStyle(.navigationLink)

                    Picker("Facultad", selection: $facultad) {
                        ForEach(Profesor.Facultad.allCases) { facultad in
                            Text(facultad.rawValue).tag(facultad)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
            }
            .navigationTitle("Nuevo Profesor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        guardarProfesor()
                    }
                    .disabled(!formularioValido) // Deshabilita el botón si falta algún campo
                }
            }
        }
    }

    private func guardarProfesor() {
        withAnimation {
            let nuevoProfesor = Profesor(
                apellido: apellido,
                nombre: nombre,
                email: email,
                telefono: telefono,
                fechaNacimiento: fechaNacimiento,
                profesion: profesion,
                contratacion: contratacion,
                estado: estado,
                facultad: facultad
            )

            modelContext.insert(nuevoProfesor)

            do {
                try modelContext.save()
                dismiss()
            } catch {
                print("Error al guardar en SwiftData: \(error.localizedDescription)")
            }
        }
    }
}
