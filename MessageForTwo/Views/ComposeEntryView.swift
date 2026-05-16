import PhotosUI
import SwiftUI
import UIKit

struct ComposeEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: MemoryStore

    @State private var kind: MemoryEntry.Kind = .update
    @State private var title = ""
    @State private var body = ""
    @State private var recipientName = "Her"
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var isLoadingPhoto = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Type") {
                    Picker("Entry type", selection: $kind) {
                        ForEach(MemoryEntry.Kind.allCases) { kind in
                            Label(kind.title, systemImage: kind.symbolName)
                                .tag(kind)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Message") {
                    TextField("Title", text: $title)
                    TextField("Who is it for?", text: $recipientName)
                    TextField("What do you want to share?", text: $body, axis: .vertical)
                        .lineLimit(4...8)
                }

                Section("Photo") {
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Label(imageData == nil ? "Choose a photo" : "Replace photo", systemImage: "photo.on.rectangle")
                    }

                    if let imageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 220)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }

                    if isLoadingPhoto {
                        ProgressView("Loading photo…")
                    }
                }
            }
            .navigationTitle("New memory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.addEntry(
                            kind: kind,
                            title: title,
                            body: body,
                            recipientName: recipientName.isEmpty ? "Her" : recipientName,
                            imageData: imageData
                        )
                        dismiss()
                    }
                    .disabled(body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .task(id: selectedPhotoItem) {
                guard let selectedPhotoItem else { return }
                await loadPhoto(from: selectedPhotoItem)
            }
        }
    }

    private func loadPhoto(from item: PhotosPickerItem) async {
        isLoadingPhoto = true
        defer { isLoadingPhoto = false }

        do {
            imageData = try await item.loadTransferable(type: Data.self)
        } catch {
            imageData = nil
        }
    }
}
