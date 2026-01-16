//
//  GameList.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 5/5/25.
//

import SwiftUI

struct GameList: View {
    // MARK: Data In
    @Environment(\.words)
    var words

    // MARK: Data Shared with Me
    @Binding
    var selection: CodeWordBreaker?

    // MARK: Data Owned by Me
    @State
    private var games: [CodeWordBreaker] = []

    @State
    private var newGameCounter = 1

    @State
    private var gameToCheat: CodeWordBreaker?

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
                games.remove(atOffsets: offsets)
            }
            .onMove { offsets, destination in
                games.move(fromOffsets: offsets, toOffset: destination)
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
                    withAnimation {
                        games.append(
                            CodeWordBreaker(
                                name: "New Game " + String(newGameCounter),
                                masterCode: words.random(length: Int.random(in: 3...6)) ?? "DEFAULT"
                            )
                        )
                        newGameCounter += 1
                    }
                } label: {
                    Label("Add Game", systemImage: "plus.circle.fill")
                        .font(.title2)
                }
            }
        }
        .onAppear {
            addSampleGames()
        }
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .onChange(of: games.map(\.lastAttemptTime)) {
            sortGamesByLru()
        }
    }

    func addSampleGames() {
        if games.isEmpty {
            games.append(CodeWordBreaker(name: "Test 1", masterCode: "TES"))
            games.append(CodeWordBreaker(name: "Test 2", masterCode: "TEST"))
            games.append(CodeWordBreaker(name: "Test 3", masterCode: "TESTT"))
        }
    }

    func sortGamesByLru() {
        withAnimation {
            games.sort {
                switch ($0.lastAttemptTime, $1.lastAttemptTime) {
                case (let d0?, let d1?):
                    return d0 > d1
                case (_?, nil):
                    return true
                case (nil, _?):
                    return false
                case (nil, nil):
                    return false
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selection: CodeWordBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
