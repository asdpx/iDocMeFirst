//
//  ScannerViewModel.swift
//  iDocMeFirst
//
//  ViewModel для экрана сканера
//

import SwiftUI
import Combine

class ScannerViewModel: ObservableObject {
    // MARK: - Published Properties
    
    // Показывать ли меню выбора источника
    @Published var showSourceSelection = false
    
    // Показывать ли галерею
    @Published var showImagePicker = false
    
    // Показывать ли предпросмотр
    @Published var showImagePreview = false
    
    // Выбранные изображения (временно, до сохранения)
    @Published var selectedImages: [UIImage] = []
    
    // Все сохранённые альбомы
    @Published var albums: [DocumentAlbum] = []
    
    // MARK: - Services
    
    private let storage = StorageService.shared
    
    // MARK: - Initialization
    
    init() {
        loadAlbums()
    }
    
    // MARK: - Actions
    
    // Открыть галерею
    func openGallery() {
        showSourceSelection = false
        
        DispatchQueue.main.async {
            self.showImagePicker = true
        }
    }
    
    // Открыть камеру (пока заглушка)
    func openCamera() {
        showSourceSelection = false
        print("📷 Камера будет добавлена на этапе 4")
    }
    
    // Когда пользователь выбрал фото из галереи
    func handleImagesSelected(_ images: [UIImage]) {
        guard !images.isEmpty else { return }
        selectedImages = images
        showImagePicker = false
        showImagePreview = true
    }
    
    // MARK: - Album Management
    
    /// Загрузить альбомы с диска при запуске
    func loadAlbums() {
        do {
            albums = try storage.loadAlbums()
            print("✅ Загружено альбомов: \(albums.count)")
        } catch {
            print("❌ Ошибка загрузки альбомов: \(error)")
            albums = []
        }
    }
    
    /// Сохранить альбом (вызывается из предпросмотра при нажатии "Далее")
    func saveAlbum(images: [UIImage]) {
        guard !images.isEmpty else { return }
        
        let newAlbum = DocumentAlbum(images: images)
        
        do {
            // 1. Сохраняем на диск
            try storage.saveAlbum(newAlbum)
            
            // 2. Добавляем в UI
            albums.insert(newAlbum, at: 0)
            
            print("✅ Альбом сохранён: \(newAlbum.title), страниц: \(newAlbum.pageCount)")
        } catch {
            print("❌ Ошибка сохранения альбома: \(error)")
        }
        
        // Очищаем временные данные
        selectedImages = []
        showImagePreview = false
    }
    
    /// Удалить альбом
    func deleteAlbum(_ album: DocumentAlbum) {
        do {
            // 1. Удаляем с диска
            try storage.deleteAlbum(album)
            
            // 2. Удаляем из UI
            albums.removeAll { $0.id == album.id }
            
            print("✅ Альбом удалён: \(album.title)")
        } catch {
            print("❌ Ошибка удаления альбома: \(error)")
        }
    }
    
    /// Переименовать альбом
    func renameAlbum(_ album: DocumentAlbum, newTitle: String) {
        // Находим индекс альбома
        guard let index = albums.firstIndex(where: { $0.id == album.id }) else {
            return
        }
        
        // Обновляем название в памяти
        albums[index].title = newTitle
        
        do {
            // Сохраняем на диск
            try storage.updateAlbum(albums[index])
            print("✅ Альбом переименован: \(newTitle)")
        } catch {
            print("❌ Ошибка переименования альбома: \(error)")
        }
    }
}
