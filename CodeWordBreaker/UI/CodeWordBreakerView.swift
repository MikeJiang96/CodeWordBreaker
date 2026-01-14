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

    // MARK: Data Shared with Me
    let game: CodeWordBreaker

    // MARK: Data Owned by Me
    @State
    private var selection: Int = 0

    @State
    private var checker = UITextChecker()

    // MARK: - Body

    var body: some View {
        VStack {
            CodeView(code: game.masterCode)

            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) {
                        Button("Guess", action: guess)
                            .flexibleSystemFont()
                            .lineLimit(1)
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
            if game.attempts.count == 0
                && (game.masterCode.word == "DEFAULT" || game.masterCode.word == "AWAIT")
            {  // don’t disrupt a game in progress
                var newMasterCode = "DEFAULT"

                if words.count == 0 {  // no words (yet)
                    newMasterCode = "AWAIT"
                } else {
                    let length = game.masterCode.pegs.count

                    newMasterCode = words.random(length: length) ?? CodeWordBreakerView.errorString(of: length)
                }

                game.restart(with: newMasterCode)
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

    static func errorString(of length: Int) -> String {
        let base = "ERROR"

        if base.count == length {
            return base
        } else if base.count > length {
            return String(base.prefix(length))
        } else {
            return base + String(repeating: "R", count: length - base.count)
        }
    }
}

#Preview {
    @Previewable @State var game = CodeWordBreaker(name: "Preview")
    NavigationStack {
        CodeWordBreakerView(game: game)
    }
}
