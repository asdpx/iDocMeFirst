

import SwiftUI
import Photos

struct SimplePhotoPicker: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedImages: [UIImage]
    
    @State private var assets: [PHAsset] = []
    @State private var selectedAssets: [PHAsset] = []
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(assets, id: \.localIdentifier) { asset in
                            PhotoGridItem(
                                asset: asset,
                                isSelected: selectedAssets.contains(asset),
                                selectionNumber: selectedAssets.firstIndex(of: asset).map { $0 + 1 },
                                containerWidth: geometry.size.width
                            )
                            .onTapGesture {
                                toggleSelection(asset)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Выбор фото")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Далее") {
                        loadSelectedImages()
                    }
                    .disabled(selectedAssets.isEmpty)
                }
            }
        }
        .onAppear {
            loadPhotos()
        }
    }
    
    private func toggleSelection(_ asset: PHAsset) {
        if let index = selectedAssets.firstIndex(of: asset) {
            selectedAssets.remove(at: index)
        } else {
            selectedAssets.append(asset)
        }
    }
    
    private func loadPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 200  // ✅ Только последние 200 фото
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var allAssets: [PHAsset] = []
        fetchResult.enumerateObjects { asset, _, _ in
            allAssets.append(asset)
        }
        
        self.assets = allAssets
    }
    
    private func loadSelectedImages() {
        var images: [UIImage] = []
        let group = DispatchGroup()
        
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .fast
        
        // ✅ Уменьшаем размер до разумного (макс 2048px)
        let targetSize = CGSize(width: 2048, height: 2048)
        
        for asset in selectedAssets {
            group.enter()
            
            imageManager.requestImage(
                for: asset,
                targetSize: targetSize,  // ✅ Вместо PHImageManagerMaximumSize
                contentMode: .aspectFit,
                options: options
            ) { image, _ in
                if let image = image {
                    // ✅ Дополнительное сжатие JPEG (качество 0.8)
                    if let compressedData = image.jpegData(compressionQuality: 0.8),
                       let compressedImage = UIImage(data: compressedData) {
                        images.append(compressedImage)
                    } else {
                        images.append(image)
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.selectedImages = images
            dismiss()
        }
    }
}

// MARK: - Grid Item
struct PhotoGridItem: View {
    let asset: PHAsset
    let isSelected: Bool
    let selectionNumber: Int?
    let containerWidth: CGFloat
    
    @State private var image: UIImage?
    
    private var itemSize: CGFloat {
        (containerWidth - 6) / 3
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: itemSize, height: itemSize)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: itemSize, height: itemSize)
            }
            
            // Галочка или номер
            if isSelected, let number = selectionNumber {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 24, height: 24)
                    
                    Text("\(number)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(8)
            } else {
                Circle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 24, height: 24)
                    .padding(8)
            }
        }
        .onAppear {
            loadThumbnail()
        }
    }
    
    private func loadThumbnail() {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        
        // ✅ Уменьшил с 200 до 120 (для миниатюр хватит)
        let size = CGSize(width: 120, height: 120)
        
        imageManager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFill,
            options: options
        ) { img, _ in
            DispatchQueue.main.async {
                self.image = img
            }
        }
    }
}
