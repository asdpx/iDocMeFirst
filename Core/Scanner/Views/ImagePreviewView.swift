import SwiftUI

struct ImagePreviewView: View {
    @Binding var images: [UIImage]
    @Binding var isPresented: Bool
    let onSave: ([UIImage]) -> Void

    @State private var selectedIndex = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if images.isEmpty {
                    emptyState
                } else {
                    mainImageView

                    Divider()

                    thumbnailStrip

                    Divider()

                    bottomBar
                }
            }
            .navigationTitle("Предпросмотр")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("обрезка")
                    } label: {
                        Label("Обрезка", systemImage: "doc.viewfinder")
                    }
                    .disabled(images.isEmpty)
                }
            }
        }
    }

    // MARK: - Subviews

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("Нет изображений")
                .foregroundColor(.secondary)
            Spacer()

            bottomBar
        }
    }

    private var mainImageView: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.easeInOut(duration: 0.25), value: selectedIndex)
        .frame(maxHeight: 420)
    }

    private var thumbnailStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                    ZStack {
                        // Фото
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        // Затемнение + корзина ТОЛЬКО для выбранной
                        if selectedIndex == index {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.45))

                            Button {
                                deleteImage(at: index)
                            } label: {
                                Image(systemName: "trash")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                selectedIndex == index ? Color.white : Color.clear,
                                lineWidth: 2
                            )
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selectedIndex = index
                        }
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .frame(height: 90)
        .background(Color(.systemGray6))
    }

    private var bottomBar: some View {
        HStack(spacing: 12) {
            Button {
                isPresented = false
            } label: {
                Text("Отмена")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.bordered)

            Button {
                onSave(images)
                isPresented = false
            } label: {
                Text("Далее")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .disabled(images.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }

    // MARK: - Actions

    private func deleteImage(at index: Int) {
        withAnimation(.easeInOut(duration: 0.25)) {
            images.remove(at: index)
            if images.isEmpty {
                selectedIndex = 0
            } else if selectedIndex >= images.count {
                selectedIndex = images.count - 1
            }
        }
    }
}
