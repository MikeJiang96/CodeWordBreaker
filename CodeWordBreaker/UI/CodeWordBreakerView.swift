//
//  ContentView.swift
//  CodeWordBreaker
//
//  Created by Mike Jiang on 2026/1/12.
//

import SwiftUI

struct CodeWordBreakerView: View {
    // MARK: Data In
    @Environment(\.words)
    var words

    // MARK: Data Owned by Me
    @State private var game = CodeWordBreaker(masterCode: "AWAIT")

    @State private var selection: Int = 0
    @State private var restarting = false

    @State private var checker = UITextChecker()

    // MARK: - Body

    var body: some View {
        VStack {
            Button("Restart", systemImage: "arrow.circlepath", action: restart)

            CodeView(code: game.masterCode)

            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) {
                        Button("Guess", action: guess).flexibleSystemFont()
                    }
                }

                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index])
                }
            }

            if !game.isOver {
                QwertyKeyboardView { letter in
                    game.setGuessPeg(letter, at: selection)
                    selection = (selection + 1) % game.masterCode.pegs.count
                }
            }
        }
        .padding()
        .onChange(of: words.count, initial: true) {
            if game.attempts.count == 0 {  // don’t disrupt a game in progress
                var newMasterCode = "DEFAULT"

                if words.count == 0 {  // no words (yet)
                    newMasterCode = "AWAIT"
                } else {
                    newMasterCode = words.random(length: game.masterCode.pegs.count) ?? "ERROR"
                }

                game.restart(with: newMasterCode)
            }
        }
    }

    func restart() {
        withAnimation(.restart) {
            restarting = true
        } completion: {
            withAnimation(.restart) {
                let newMasterCode =
                    words.random(length: Int.random(in: 3...6)) ?? "NOWORD"

                game.restart(with: newMasterCode)

                selection = 0
                restarting = false
            }
        }
    }

    func guess() {
        if checker.isAWord(game.guess.word) {
            withAnimation(.guess) {
                game.attemptGuess()
                selection = 0
            }
        }
    }
}

#Preview {
    CodeWordBreakerView()
}
