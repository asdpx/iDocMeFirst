

import Foundation
//
//  SettingsView.swift
//  DocumentScannerApp
//
//  Экран настроек (будет разработан на этапе 3)
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "gear")
                    .font(.system(size: 80))
                    .foregroundColor(.gray)
                    .padding()
                
                Text("Настройки")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Этот экран будет разработан позже")
                    .foregroundColor(.secondary)
                    .padding()
            }
            .navigationTitle("Настройки")
        }
    }
}

#Preview {
    SettingsView()
}
