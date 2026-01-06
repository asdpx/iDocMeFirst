//
//  AlbumMetadata.swift
//  iDocMeFirst
//
//  Метаданные альбома для сохранения в JSON
//

import Foundation

/// Метаданные альбома (без фото)
/// Используется для сохранения/загрузки информации об альбоме в JSON формате
struct AlbumMetadata: Codable {
    /// Уникальный идентификатор альбома
    let id: UUID
    
    /// Название альбома
    let title: String
    
    /// Дата создания альбома
    let createdDate: Date
    
    /// Количество фотографий в альбоме
    let imageCount: Int
}
