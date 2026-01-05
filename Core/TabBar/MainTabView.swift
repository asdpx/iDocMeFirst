//
//  MainTabView.swift
//  DocumentScannerApp
//
//  Главный TabView с тремя вкладками
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // ЭКРАН 1: Сканер
            ScannerView()
                .tabItem {
                    Label("Сканер", systemImage: "doc.text.viewfinder")
                }
            
            // ЭКРАН 2: Сущности (пока заглушка)
            EntitiesView()
                .tabItem {
                    Label("Сущности", systemImage: "person.2.fill")
                }
            
            // ЭКРАН 3: Настройки (пока заглушка)
            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gear")
                }
        }
        
    }
}

#Preview {
    MainTabView()
}
