import SwiftUI

@main
struct MessageForTwoApp: App {
    @StateObject private var store = MemoryStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
