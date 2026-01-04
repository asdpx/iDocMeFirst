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
            .sheet(isPresented: $showSourceSelection) {
                SourceSelectionSheet(
                    onCameraSelected: {
                        // TODO: Открыть камеру-сканер
                        print("Открыть камеру")
                    },
                    onGallerySelected: {
                        // TODO: Открыть галерею
                        print("Открыть галерею")
                    }
                )
            }
        }
    }
}

#Preview {
    ScannerView()
}
