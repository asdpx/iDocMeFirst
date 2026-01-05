////
////  ImagePickerService.swift
////  iDocMeFirst
////
////  Сервис для выбора изображений из галереи
////
//
//import SwiftUI
//import PhotosUI
//
//// MARK: - ImagePicker
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var selectedImages: [UIImage]
//    @Environment(\.dismiss) var dismiss
//    
//    // Создаём PHPickerViewController (стандартный выбор фото iOS)
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        var configuration = PHPickerConfiguration()
//        configuration.filter = .images  // Только изображения
//        configuration.selectionLimit = 0  // 0 = без лимита (можно выбрать много)
//        
//        let picker = PHPickerViewController(configuration: configuration)
//        picker.delegate = context.coordinator
//        return picker
//    }
//    
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
//        // Ничего не делаем
//    }
//    
//    // Создаём координатор (обработчик событий)
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    // MARK: - Coordinator
//    class Coordinator: NSObject, PHPickerViewControllerDelegate {
//        let parent: ImagePicker
//        
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//        
//        // Вызывается когда пользователь выбрал фото
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            // Если пользователь отменил выбор
//            if results.isEmpty {
//                parent.dismiss()
//                return
//            }
//            
//            // Загружаем выбранные изображения
//            var images: [UIImage] = []
//            let group = DispatchGroup()
//            
//            for result in results {
//                group.enter()
//                
//                result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
//                    defer { group.leave() }
//                    
//                    if let error = error {
//                        print("❌ Ошибка загрузки: \(error.localizedDescription)")
//                        return
//                    }
//                    
//                    if let image = object as? UIImage {
//                        images.append(image)
//                    }
//                }
//            }
//            
//            // Когда все фото загружены
//            group.notify(queue: .main) {
//                self.parent.selectedImages = images
//                self.parent.dismiss()
//            }
//        }
//    }
//}
