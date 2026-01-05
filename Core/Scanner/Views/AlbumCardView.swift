//
//  AlbumCardView.swift
//  iDocMeFirst
//
//  Карточка альбома для списка
//

import SwiftUI

struct AlbumCardView: View {
    let album: DocumentAlbum
    
    var body: some View {
        HStack(spacing: 12) {
            // Обложка (первое фото)
            if let coverImage = album.coverImage {
                Image(uiImage: coverImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
            }
            
            // Информация об альбоме
            VStack(alignment: .leading, spacing: 4) {
                Text(album.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(album.formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(album.pageCount) стр.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
//        .padding()
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding()
         .background(.ultraThinMaterial)  // ← Вместо Color(.systemBackground)
         .cornerRadius(12)
         .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    AlbumCardView(
        album: DocumentAlbum(
            title: "Паспорт",
            images: [UIImage(systemName: "doc.text")!].compactMap { $0 }
        )
    )
    .padding()
}
