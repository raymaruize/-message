import Foundation

struct MemoryEntry: Identifiable, Codable, Equatable {
    enum Kind: String, Codable, CaseIterable, Identifiable {
        case update
        case quote
        case fact
        case photo

        var id: String { rawValue }

        var title: String {
            switch self {
            case .update:
                return "Update"
            case .quote:
                return "Quote"
            case .fact:
                return "Fact"
            case .photo:
                return "Photo"
            }
        }

        var symbolName: String {
            switch self {
            case .update:
                return "message.fill"
            case .quote:
                return "quote.bubble.fill"
            case .fact:
                return "sparkles"
            case .photo:
                return "photo.fill"
            }
        }
    }

    let id: UUID
    let createdAt: Date
    var kind: Kind
    var title: String
    var body: String
    var recipientName: String
    var imageData: Data?

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        kind: Kind,
        title: String,
        body: String,
        recipientName: String,
        imageData: Data? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.kind = kind
        self.title = title
        self.body = body
        self.recipientName = recipientName
        self.imageData = imageData
    }
}
