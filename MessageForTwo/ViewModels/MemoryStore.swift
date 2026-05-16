import Foundation

@MainActor
final class MemoryStore: ObservableObject {
    @Published private(set) var entries: [MemoryEntry] = [] {
        didSet { persistEntries() }
    }

    private let defaults: UserDefaults
    private let storageKey = "message-for-two.entries"
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
        loadEntries()
    }

    func addEntry(kind: MemoryEntry.Kind, title: String, body: String, recipientName: String, imageData: Data?) {
        let cleanedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedBody = body.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedRecipient = recipientName.trimmingCharacters(in: .whitespacesAndNewlines)

        let entry = MemoryEntry(
            kind: kind,
            title: cleanedTitle.isEmpty ? kind.title : cleanedTitle,
            body: cleanedBody,
            recipientName: cleanedRecipient.isEmpty ? "Her" : cleanedRecipient,
            imageData: imageData
        )

        entries.insert(entry, at: 0)
    }

    func entries(matching filter: MemoryEntry.Kind?) -> [MemoryEntry] {
        guard let filter else { return entries }
        return entries.filter { $0.kind == filter }
    }

    private func loadEntries() {
        guard let data = defaults.data(forKey: storageKey) else {
            entries = Self.seedEntries
            return
        }

        do {
            entries = try decoder.decode([MemoryEntry].self, from: data)
        } catch {
            entries = Self.seedEntries
        }
    }

    private func persistEntries() {
        do {
            let data = try encoder.encode(entries)
            defaults.set(data, forKey: storageKey)
        } catch {
            assertionFailure("Failed to save entries: \(error)")
        }
    }
}

private extension MemoryStore {
    static let seedEntries: [MemoryEntry] = [
        MemoryEntry(
            createdAt: .now.addingTimeInterval(-1_800),
            kind: .update,
            title: "Made it home",
            body: "Home safe. Thinking of you and making tea before bed.",
            recipientName: "You"
        ),
        MemoryEntry(
            createdAt: .now.addingTimeInterval(-21_600),
            kind: .quote,
            title: "Tiny love note",
            body: "You make ordinary days feel cinematic.",
            recipientName: "Her"
        ),
        MemoryEntry(
            createdAt: .now.addingTimeInterval(-86_400),
            kind: .fact,
            title: "A favorite thing",
            body: "I still smile every time I remember our first rainy walk.",
            recipientName: "Her"
        )
    ]
}
