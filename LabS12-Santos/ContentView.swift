//
//  ContentView.swift
//  LabS12-Santos
//
//  Created by Tecsup on 1/06/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var buscador: String = ""
    @State private var profesorSeleccionado: Profesor?
    @State private var mostrarNuevoProfesor = false

    @Query(sort: \Profesor.apellido) private var profesores: [Profesor]

    private var filteredProfesores: [Profesor] {
        if buscador.isEmpty { return profesores }
        return profesores.filter {
            $0.apellido.localizedCaseInsensitiveContains(buscador) ||
            $0.nombre.localizedCaseInsensitiveContains(buscador) ||
            $0.telefono.contains(buscador)
        }
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $profesorSeleccionado) {
                ForEach(filteredProfesores) { profesor in
                    NavigationLink(value: profesor) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(profesor.apellido), \(profesor.nombre)")
                                    .font(.headline)
                                    .foregroundStyle(profesor.estado == .activo ? .primary : .secondary)

                                QHStack {
                                    Image(systemName: profesor.estado == .activo ? "checkmark.circle.fill" : "xmark.seal.fill")
                                        .foregroundColor(profesor.estado == .activo ? .green : .red)

                                    Text(profesor.facultad.rawValue)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()

                            Text(profesor.telefono)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteProfesores)
            }
            .navigationTitle("Profesores")
            .searchable(text: $buscador, prompt: "Buscar profesor...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        mostrarNuevoProfesor.toggle()
                    } label: {
                        Label("Nuevo", systemImage: "plus")
                    }
                }
            }
            // Controla el destino de navegación de manera centralizada
            .navigationDestination(for: Profesor.self) { profesor in
                ProfesorDetailView(profesor: profesor)
            }
            // Despliega el formulario de inserción de forma limpia
            .sheet(isPresented: $mostrarNuevoProfesor) {
                NuevoProfesorView()
            }
        } detail: {
            if let profesor = profesorSeleccionado {
                ProfesorDetailView(profesor: profesor)
            } else {
                ContentUnavailableView("Selecciona un profesor", systemImage: "person.crop.circle")
            }
        }
    }

    private func deleteProfesores(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let profesorABorrar = filteredProfesores[index]
                
                // Si el profesor eliminado estaba seleccionado, limpiamos el detalle
                if profesorSeleccionado?.idProfesor == profesorABorrar.idProfesor {
                    profesorSeleccionado = nil
                }
                
                modelContext.delete(profesorABorrar)
            }
            
            try? modelContext.save()
        }
    }
}

struct ProfesorDetailView: View {
    @Bindable var profesor: Profesor
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Form {
            Section(header: Text("Información Personal")) {
                HStack(spacing: 12) {
                    CircleImageView(estado: profesor.estado)
                    Text(profesor.estado.rawValue)
                        .font(.callout)
                        .fontWeight(.medium)
                }

                LabeledContent("Nombre", value: "\(profesor.apellido), \(profesor.nombre)")
                LabeledContent("Email", value: profesor.email)
                    .foregroundStyle(.blue)
                LabeledContent("Teléfono", value: profesor.telefono)

                DateRow(title: "Nacimiento", date: profesor.fechaNacimiento)
                DateRow(title: "Contratado", date: profesor.contratacion)
            }

            Section(header: Text("Datos Profesionales")) {
                LabeledContent("Profesión", value: profesor.profesion)
                LabeledContent("Facultad", value: profesor.facultad.rawValue)
            }

            Section {
                Button(role: profesor.estado == .activo ? .destructive : nil) {
                    withAnimation {
                        profesor.estado = (profesor.estado == .activo) ? .inactivo : .activo
                        try? modelContext.save()
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text(profesor.estado == .activo ? "Desactivar Profesor" : "Activar Profesor")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Detalles")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CircleImageView: View {
    let estado: Profesor.Estado

    var body: some View {
        Image(systemName: estado == .activo ? "checkmark.circle.fill" : "xmark.icloud.fill")
            .font(.title2)
            .foregroundStyle(estado == .activo ? .green : .red)
    }
}

struct DateRow: View {
    let title: String
    let date: Date

    private var fechaFormateada: String {
        date.formatted(.dateTime.day().month(.abbreviated).year())
    }

    var body: some View {
        LabeledContent(title, value: fechaFormateada)
    }
}

// Contenedor HStack auxiliar simple
struct QHStack<Content: View>: View {
    let content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    var body: some View { HStack(spacing: 6, content: content) }
}
