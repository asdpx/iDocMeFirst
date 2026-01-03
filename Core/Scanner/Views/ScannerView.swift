//
//  ScannerView.swift
//  DocumentScannerApp
//
//  Главный экран сканера документов
//

import SwiftUI

struct ScannerView: View {
    // Состояние для отображения меню выбора источника
    @State private var showSourceSelection = false
    
    var body: some View {
        NavigationView {
            ZStack {  // ← Вместо VStack используем ZStack
                
                // Основной контент
                VStack {
                    Text("Здесь будут отображаться\nотсканированные документы")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer()
                }
                
                // Кнопка прилипла к низу
                VStack {
                    Spacer()
                    
                    Button(action: {
                        showSourceSelection = true
                    }) {
                        HStack {
                            Image(systemName: "doc.text.viewfinder")
                                .font(.title2)
                            
                            Text("Сканировать документ")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Сканер")
            .confirmationDialog("Выберите источник", isPresented: $showSourceSelection) {
                Button("Камера (сканер)") {
                    // TODO: Открыть камеру-сканер
                    print("Открыть камеру")
                }
                
                Button("Галерея") {
                    // TODO: Открыть галерею
                    print("Открыть галерею")
                }
                
                Button("Отмена", role: .cancel) { }
            } message: {
                Text("Откуда взять документ?")
            }
        }
    }
}

#Preview {
    ScannerView()
}
