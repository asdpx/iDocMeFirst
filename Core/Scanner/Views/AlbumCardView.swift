





//
//  AlbumCardView.swift
//  iDocMeFirst
//
//  Карточка альбома с кастомным свайпом для удаления
//

import SwiftUI

struct AlbumCardView: View {
    let album: DocumentAlbum
    let onDelete: () -> Void

    var body: some View {
        cardContent
            // важно: чтобы свайп работал по всей “карточке”, а не только по тексту/иконкам
            .contentShape(Rectangle())
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("Удалить", systemImage: "trash")
                        //.tint(.red)
                }
                .tint(.red)
            }
    }

    private var cardContent: some View {
        HStack(spacing: 12) {
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
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    AlbumCardView(
        album: DocumentAlbum(
            title: "Паспорт",
            images: [UIImage(systemName: "doc.text")!]
        ),
        onDelete: { print("Deleted") }
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}







//
//
//
//
//
//
////
////  AlbumCardView.swift
////  iDocMeFirst
////
////  Карточка альбома с кастомным свайпом для удаления
////
//
//import SwiftUI
//
//struct AlbumCardView: View {
//    let album: DocumentAlbum
//    let onDelete: () -> Void
//    
//    @State private var offset: CGFloat = 0
//    @State private var isDeletable = false
//    @State private var hapticTriggered = false
//    
//    var body: some View {
//        ZStack(alignment: .leading) {
//            // 1. КАРТОЧКА АЛЬБОМА (НЕ ДВИГАЕТСЯ)
//            cardContent
//            
//            // 2. КРАСНЫЙ СЛОЙ СВЕРХУ (НАКРЫВАЕТ СПРАВА НАЛЕВО)
//            if offset < 0 {
//                deleteOverlay
//            }
//        }
//        .gesture(
//            DragGesture()
//                .onChanged { gesture in
//                    handleDragChanged(gesture)
//                }
//                .onEnded { _ in
//                    handleDragEnded()
//                }
//        )
//    }
//    
//    // MARK: - Карточка альбома
//    
//    private var cardContent: some View {
//        HStack(spacing: 12) {
//            // Обложка (первое фото)
//            if let coverImage = album.coverImage {
//                Image(uiImage: coverImage)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 80, height: 80)
//                    .clipShape(RoundedRectangle(cornerRadius: 8))
//            } else {
//                RoundedRectangle(cornerRadius: 8)
//                    .fill(Color.gray.opacity(0.2))
//                    .frame(width: 80, height: 80)
//                    .overlay {
//                        Image(systemName: "photo")
//                            .foregroundColor(.gray)
//                    }
//            }
//            
//            // Информация об альбоме
//            VStack(alignment: .leading, spacing: 4) {
//                Text(album.title)
//                    .font(.headline)
//                    .lineLimit(1)
//                
//                Text(album.formattedDate)
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                
//                Text("\(album.pageCount) стр.")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//            
//            Spacer()
//            
//            Image(systemName: "chevron.right")
//                .foregroundColor(.gray)
//        }
//        .padding()
//        .background(.ultraThinMaterial)
//        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
//    }
//    
//    // MARK: - Красный слой с корзиной
//    
//    private var deleteOverlay: some View {
//        GeometryReader { geometry in
//            let deleteThreshold = -geometry.size.width * 0.65  // ✅ 65% ширины карточки
//            
//            HStack {
//                Spacer()
//                
//                Image(systemName: isDeletable ? "trash.fill" : "trash")
//                    .font(.title)
//                    .foregroundColor(.white)
//                    .scaleEffect(isDeletable ? 1.2 : 1.0)
//                    .animation(.spring(response: 0.3), value: isDeletable)
//                    .padding(.trailing, 30)
//            }
//            .frame(width: abs(offset), height: geometry.size.height)
//            .background(
//                Color.red.opacity(min(1.0, abs(offset) / (geometry.size.width * 0.8)))
//                //                              ✅ 80% ширины = полный красный
//            )
//            .cornerRadius(12)
//            .offset(x: geometry.size.width + offset)
//            .onChange(of: offset) { oldValue, newValue in
//                checkDeleteThreshold(newValue, threshold: deleteThreshold)
//            }
//        }
//    }
//    
//    // MARK: - Gesture Handlers
//    
//    private func handleDragChanged(_ gesture: DragGesture.Value) {
//        // Только влево (отрицательный offset)
//        if gesture.translation.width < 0 {
//            offset = gesture.translation.width
//            // Проверка порога происходит в onChange внутри deleteOverlay
//        }
//    }
//    
//    private func handleDragEnded() {
//        if isDeletable {
//            // УДАЛИТЬ! Красный слой накрывает полностью
//            withAnimation(.easeOut(duration: 0.4)) {
//                offset = -400
//            }
//            
//            // Удаляем альбом через 0.4 сек (после анимации)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                onDelete()
//            }
//        } else {
//            // ОТМЕНИТЬ - красный слой исчезает
//            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
//                offset = 0
//            }
//        }
//        
//        hapticTriggered = false
//    }
//    
//    // MARK: - Threshold Check
//    
//    /// Проверка порога удаления с вибро-откликами
//    private func checkDeleteThreshold(_ currentOffset: CGFloat, threshold: CGFloat) {
//        if currentOffset < threshold && !isDeletable {
//            // ВОШЛИ В ПОРОГ → ВИБРАЦИЯ 1 📳
//            isDeletable = true
//            triggerHaptic()
//            hapticTriggered = true
//        } else if currentOffset >= threshold && isDeletable {
//            // ВЫШЛИ ИЗ ПОРОГА → ВИБРАЦИЯ 2 📳 (ПЕРЕДУМАЛ!)
//            isDeletable = false
//            triggerHaptic()
//            hapticTriggered = false
//        }
//    }
//    
//    private func triggerHaptic() {
//        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
//        impactFeedback.impactOccurred()
//        hapticTriggered = true
//    }
//}
//
//#Preview {
//    AlbumCardView(
//        album: DocumentAlbum(
//            title: "Паспорт",
//            images: [UIImage(systemName: "doc.text")!].compactMap { $0 }
//        ),
//        onDelete: {
//            print("Удалено!")
//        }
//    )
//    .padding()
//}
