//
//  ScannerViewModel.swift
//  iDocMeFirst
//
//  ViewModel для экрана сканера
//

import SwiftUI
internal import Combine

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
    
    // Сохранить альбом (вызывается из предпросмотра при нажатии "Далее")
    func saveAlbum(images: [UIImage]) {
        guard !images.isEmpty else { return }
        
        let newAlbum = DocumentAlbum(images: images)
        albums.insert(newAlbum, at: 0)  // Добавляем в начало списка
        
        // Очищаем временные данные
        selectedImages = []
        showImagePreview = false
        
        print("✅ Альбом сохранён: \(newAlbum.title), страниц: \(newAlbum.pageCount)")
    }
}
