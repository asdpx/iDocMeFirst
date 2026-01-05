//
//  DocumentAlbum.swift
//  iDocMeFirst
//
//  Модель для хранения альбома отсканированных документов
//

import SwiftUI

struct DocumentAlbum: Identifiable {
    // Уникальный ID (генерируется автоматически)
    let id: UUID
    
    // Дата создания (НЕЛЬЗЯ изменить)
    let createdDate: Date
    
    // Название альбома (МОЖНО изменить)
    var title: String
    
    // Массив фотографий
    var images: [UIImage]
    
    // Инициализатор (создание альбома)
    init(id: UUID = UUID(), createdDate: Date = Date(), title: String = "", images: [UIImage] = []) {
        self.id = id
        self.createdDate = createdDate
        // Если название пустое → используем дату
        self.title = title.isEmpty ? DocumentAlbum.formatDate(createdDate) : title
        self.images = images
    }
    
    // Функция форматирования даты (превращает Date в строку)
    private static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: date)
    }
    
    // Получить дату как строку для отображения
    var formattedDate: String {
        DocumentAlbum.formatDate(createdDate)
    }
    
    // Количество страниц в альбоме
    var pageCount: Int {
        images.count
    }
    
    // Первое фото (для обложки)
    var coverImage: UIImage? {
        images.first
    }
}
