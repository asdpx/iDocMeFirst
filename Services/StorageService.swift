//
//  StorageService.swift
//  iDocMeFirst
//
//  Сервис для сохранения и загрузки альбомов
//

import Foundation
import UIKit

class StorageService {
    // Singleton (один экземпляр на всё приложение)
    static let shared = StorageService()
    
    private init() {}
    
    // MARK: - Пути к папкам
    
    // Главная папка Documents
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // Папка для всех альбомов: Documents/Albums/
    private var albumsDirectory: URL {
        documentsDirectory.appendingPathComponent("Albums")
    }
    
    // MARK: - Основные функции
    
    /// Сохранить альбом на диск
    func saveAlbum(_ album: DocumentAlbum) throws {
        // 1. Создаём папку для альбома
        let albumFolder = albumsDirectory.appendingPathComponent(album.id.uuidString)
        try FileManager.default.createDirectory(at: albumFolder, withIntermediateDirectories: true)
        
        // 2. Сохраняем каждое фото как JPG
        for (index, image) in album.images.enumerated() {
            let imageURL = albumFolder.appendingPathComponent("\(index).jpg")
            
            // Сжимаем в JPEG (80% качество)
            if let data = image.jpegData(compressionQuality: 0.8) {
                try data.write(to: imageURL)
            }
        }
        
        // 3. Сохраняем метаданные
        let metadata = AlbumMetadata(
            id: album.id,
            title: album.title,
            createdDate: album.createdDate,
            imageCount: album.images.count
        )
        
        let metadataURL = albumFolder.appendingPathComponent("metadata.json")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(metadata)
        try jsonData.write(to: metadataURL)
        
        print("✅ Альбом сохранён: \(albumFolder.path)")
    }
    
    /// Загрузить все альбомы с диска
    func loadAlbums() throws -> [DocumentAlbum] {
        var albums: [DocumentAlbum] = []
        
        // Проверяем существует ли папка Albums
        guard FileManager.default.fileExists(atPath: albumsDirectory.path) else {
            print("📁 Папка Albums не существует, создаём...")
            try FileManager.default.createDirectory(at: albumsDirectory, withIntermediateDirectories: true)
            return []
        }
        
        // Получаем все папки в Albums/
        let albumFolders = try FileManager.default.contentsOfDirectory(
            at: albumsDirectory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )
        
        // Для каждой папки
        for folder in albumFolders {
            do {
                // Читаем metadata.json
                let metadataURL = folder.appendingPathComponent("metadata.json")
                let jsonData = try Data(contentsOf: metadataURL)
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let metadata = try decoder.decode(AlbumMetadata.self, from: jsonData)
                
                // Загружаем все фото
                var images: [UIImage] = []
                for i in 0..<metadata.imageCount {
                    let imageURL = folder.appendingPathComponent("\(i).jpg")
                    
                    if let imageData = try? Data(contentsOf: imageURL),
                       let image = UIImage(data: imageData) {
                        images.append(image)
                    }
                }
                
                // Создаём альбом
                let album = DocumentAlbum(
                    id: metadata.id,
                    createdDate: metadata.createdDate,
                    title: metadata.title,
                    images: images
                )
                
                albums.append(album)
            } catch {
                print("⚠️ Ошибка загрузки альбома из \(folder.lastPathComponent): \(error)")
            }
        }
        
        // Сортируем по дате (новые первые)
        albums.sort { $0.createdDate > $1.createdDate }
        
        print("✅ Загружено альбомов: \(albums.count)")
        return albums
    }
    
    /// Удалить альбом с диска
    func deleteAlbum(_ album: DocumentAlbum) throws {
        let albumFolder = albumsDirectory.appendingPathComponent(album.id.uuidString)
        try FileManager.default.removeItem(at: albumFolder)
        
        print("✅ Альбом удалён: \(album.title)")
    }
    
    /// Обновить альбом (для переименования)
    func updateAlbum(_ album: DocumentAlbum) throws {
        let albumFolder = albumsDirectory.appendingPathComponent(album.id.uuidString)
        
        // Обновляем только metadata.json
        let metadata = AlbumMetadata(
            id: album.id,
            title: album.title,
            createdDate: album.createdDate,
            imageCount: album.images.count
        )
        
        let metadataURL = albumFolder.appendingPathComponent("metadata.json")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(metadata)
        try jsonData.write(to: metadataURL)
        
        print("✅ Альбом обновлён: \(album.title)")
    }
}

// MARK: - AlbumMetadata (для JSON)

struct AlbumMetadata: Codable {
    let id: UUID
    let title: String
    let createdDate: Date
    let imageCount: Int
}
