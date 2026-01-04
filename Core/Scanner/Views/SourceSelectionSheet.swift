//
//  SourceSelectionSheet.swift
//  DocumentScannerApp
//
//  Всплывающее окно выбора источника документа
//

import SwiftUI

struct SourceSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    let onCameraSelected: () -> Void
    let onGallerySelected: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовок
            VStack(spacing: 8) {
                Text("Выберите источник")
                    .font(.headline)
                Text("Откуда взять документ?")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            Divider()
            
            // Кнопки выбора
            VStack(spacing: 0) {
                Button(action: {
                    dismiss()
                    onCameraSelected()
                }) {
                    HStack {
                        Image(systemName: "camera")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Text("Камера (сканер)")
                            .font(.body)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding()
                    .contentShape(Rectangle())
                }
                
                Divider()
                    .padding(.leading)
                
                Button(action: {
                    dismiss()
                    onGallerySelected()
                }) {
                    HStack {
                        Image(systemName: "photo.on.rectangle")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Text("Галерея")
                            .font(.body)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding()
                    .contentShape(Rectangle())
                }
            }
            
            Divider()
            
            // Кнопка отмены
            Button(action: {
                dismiss()
            }) {
                Text("Отмена")
                    .font(.body)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            
            Spacer()
        }
        .presentationDetents([.height(280)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    SourceSelectionSheet(
        onCameraSelected: { print("Камера выбрана") },
        onGallerySelected: { print("Галерея выбрана") }
    )
}
