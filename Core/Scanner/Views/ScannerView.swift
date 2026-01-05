//
//  ScannerView.swift
//  iDocMeFirst
//
//  Главный экран сканера документов
//

import SwiftUI

struct ScannerView: View {
    @StateObject private var viewModel = ScannerViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                // ✅ Системный фон (профессионально)
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                // Основной контент
                Group {
                    if viewModel.albums.isEmpty {
                        emptyStateView
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    } else {
                        albumsListView
                    }
                }

                // Кнопка сканирования
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        scanButton
                    }
                }
            }
            .navigationTitle("Сканер")
            .navigationBarTitleDisplayMode(.large)

            // MARK: - Sheets

            .sheet(isPresented: $viewModel.showSourceSelection) {
                SourceSelectionSheet(
                    onCameraSelected: viewModel.openCamera,
                    onGallerySelected: viewModel.openGallery
                )
            }

            .fullScreenCover(isPresented: $viewModel.showImagePicker, onDismiss: {
                if !viewModel.selectedImages.isEmpty {
                    viewModel.showImagePreview = true
                }
            }) {
                SimplePhotoPicker(selectedImages: $viewModel.selectedImages)
            }

            .sheet(isPresented: $viewModel.showImagePreview) {
                ImagePreviewView(
                    images: $viewModel.selectedImages,
                    isPresented: $viewModel.showImagePreview,
                    onSave: viewModel.saveAlbum
                )
            }
        }
        .tint(.blue)
    }

    // MARK: - Subviews
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.viewfinder")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("Нет отсканированных документов")
                .font(.headline)
                .foregroundStyle(.primary)

            Text("Нажмите кнопку ниже, чтобы начать")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .padding()
    }

    private var albumsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.albums) { album in
                    AlbumCardView(album: album)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 120)
        }
    }

    // Стеклянная кнопка
    private var scanButton: some View {
        Button {
            viewModel.showSourceSelection = true
        } label: {
            Image(systemName: "doc.text.viewfinder")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(.blue)
                .frame(width: 64, height: 64)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        .padding(.trailing, 40)
        .padding(.bottom, 30)
    }
}

#Preview {
    ScannerView()
}
