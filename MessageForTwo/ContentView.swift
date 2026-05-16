import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: MemoryStore
    @State private var selectedFilter: MemoryEntry.Kind?
    @State private var showingComposer = false

    private var filteredEntries: [MemoryEntry] {
        store.entries(matching: selectedFilter)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    heroCard
                    filterChips

                    if filteredEntries.isEmpty {
                        emptyState
                    } else {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredEntries) { entry in
                                EntryCard(entry: entry)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Message for Two")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingComposer = true
                    } label: {
                        Label("Add memory", systemImage: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingComposer) {
                ComposeEntryView()
                    .environmentObject(store)
            }
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("A private place for the little things")
                .font(.title2.bold())
            Text("Save updates, quotes, facts, and photos so the two of you always have a soft place to come back to.")
                .font(.body)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                statChip(title: "Entries", value: "\(store.entries.count)")
                statChip(title: "Photos", value: "\(store.entries.filter { $0.imageData != nil }.count)")
                statChip(title: "Ready", value: "Local MVP")
            }
        }
        .padding(22)
        .background(
            LinearGradient(
                colors: [Color.pink.opacity(0.24), Color.purple.opacity(0.18)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 28)
        )
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                filterButton(title: "All", isSelected: selectedFilter == nil) {
                    selectedFilter = nil
                }

                ForEach(MemoryEntry.Kind.allCases) { kind in
                    filterButton(title: kind.title, isSelected: selectedFilter == kind) {
                        selectedFilter = kind
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 40))
                .foregroundStyle(.pink)

            Text("Nothing here yet")
                .font(.headline)

            Text("Add the first memory and start shaping the app you can later ship through TestFlight.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(30)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
    }

    private func statChip(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 16))
    }

    private func filterButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    isSelected ? Color.pink : Color(uiColor: .secondarySystemBackground),
                    in: Capsule()
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
}
