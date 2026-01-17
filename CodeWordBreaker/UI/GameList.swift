//
//  GameList.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 5/5/25.
//

import SwiftData
import SwiftUI

struct GameList: View {
    // MARK: Data In
    @Environment(\.modelContext)
    var modelContext

    @Environment(\.words)
    var words

    // MARK: Data Shared with Me
    @Binding
    var selection: CodeWordBreaker?

    @Query
    private var games: [CodeWordBreaker] = []

    // MARK: Data Owned by Me
    static let newGameCounterKey = "NewGameCounter"
    static let newGameCounterMax = 99

    @State
    private var gameToCheat: CodeWordBreaker?

    private var newGameCounter: Int {
        let counter = UserDefaults.incrementInt(forKey: GameList.newGameCounterKey)
        return counter
    }

    init(
        filterBy filterOption: FilterOption,
        masterCodeOrAttemptsContains search: String,
        selection: Binding<CodeWordBreaker?>
    ) {
        _selection = selection

        let uppercaseSearch = search.uppercased()

        let predicate: Predicate<CodeWordBreaker>

        // FIXME: Compiler will not work if write in one line
        switch filterOption {
        case .none:
            predicate = #Predicate { game in
                search.isEmpty
                    || game.masterCode._pegs.contains(uppercaseSearch)
                    || game._attempts.contains { attempt in attempt._pegs.contains(uppercaseSearch) }
            }
        case .uncompleted:
            predicate = #Predicate { game in
                (search.isEmpty
                    || game.masterCode._pegs.contains(uppercaseSearch)
                    || game._attempts.contains { attempt in attempt._pegs.contains(uppercaseSearch) })
                    && !game.isOver
            }
        case .completed:
            predicate = #Predicate { game in
                (search.isEmpty
                    || game.masterCode._pegs.contains(uppercaseSearch)
                    || game._attempts.contains { attempt in attempt._pegs.contains(uppercaseSearch) })
                    && game.isOver
            }
        }

        _games = Query(
            filter: predicate,
            sort: [
                SortDescriptor(\CodeWordBreaker.lastAttemptTime, order: .reverse),
                SortDescriptor(\CodeWordBreaker.name, order: .forward),
            ]
        )
    }

    enum FilterOption: CaseIterable {
        case none
        case uncompleted
        case completed

        var title: String {
            switch self {
            case .none: "All"
            case .uncompleted: "Uncompleted"
            case .completed: "Completed"
            }
        }
    }

    // MARK: - Body

    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .swipeActions(edge: .leading) {
                    Button {
                        gameToCheat = game
                    } label: {
                        Label("Cheat", systemImage: "eye")
                    }
                    .tint(.orange)
                }
            }
            .onDelete { offsets in
                for offset in offsets {
                    modelContext.delete(games[offset])
                }
            }
        }
        .sheet(item: $gameToCheat) { game in
            CodeBasicView(code: game.masterCode)
                .padding()
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }

            ToolbarItem(placement: .bottomBar) {
                Button {
                    let newGameCounterValue = newGameCounter
                    let newGameName = {
                        if newGameCounterValue < GameList.newGameCounterMax {
                            return "New Game " + String(format: "%02d", newGameCounterValue)
                        } else {
                            if let randomName = words.random(length: Int.random(in: 3...6)) {
                                return "New Game " + GameList.lowercaseAfterFirst(randomName)
                            } else {
                                return "Default Game Name"
                            }
                        }
                    }()

                    withAnimation {
                        modelContext.insert(
                            CodeWordBreaker(
                                name: newGameName,
                                masterCode: words.random(length: Int.random(in: 3...6)) ?? "DEFAULT"
                            )
                        )
                    }
                } label: {
                    Label("Add Game", systemImage: "plus.circle.fill")
                        .font(.title2)
                }
            }
        }
        .onAppear {
            // Store filterOption and addSampleGames() only when .none
            // Then we can use games.count as condition
            addSampleGames()
        }
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
    }

    func addSampleGames() {
        let fetchDescriptor = FetchDescriptor<CodeWordBreaker>()

        if let results = try? modelContext.fetchCount(fetchDescriptor) {
            print("results = \(results)")

            if results == 0 {
                modelContext.insert(CodeWordBreaker(name: "Default 1", masterCode: "TES"))
                modelContext.insert(CodeWordBreaker(name: "Default 2", masterCode: "TEST"))
            }
        }
    }

    static func lowercaseAfterFirst(_ text: String) -> String {
        guard let first = text.first else { return text }
        return String(first) + text.dropFirst().lowercased()
    }
}

#Preview {
    @Previewable @State var selection: CodeWordBreaker?
    NavigationStack {
        GameList(filterBy: .none, masterCodeOrAttemptsContains: "", selection: $selection)
    }
}
