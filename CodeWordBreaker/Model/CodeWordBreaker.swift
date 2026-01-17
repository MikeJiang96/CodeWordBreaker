//
//  CodeWordBreaker.swift
//  CodeWordBreaker
//
//  Created by Mike Jiang on 2026/1/11.
//

import Foundation
import SwiftData

typealias Peg = String

@Model
class CodeWordBreaker {
    var name: String

    @Relationship(deleteRule: .cascade)
    var masterCode: Code

    @Relationship(deleteRule: .cascade)
    var guess: Code

    @Relationship(deleteRule: .cascade)
    var _attempts = [Code]()

    var pegChoices: [Peg]
    var lastAttemptTime: Date?

    var isOver: Bool = false

    init(name: String = "CodeWord Breaker", masterCode: String = "DEFAULT") {
        pegChoices = "QWERTYUIOPASDFGHJKLZXCVBNM".map { String($0) }

        self.name = name
        self.masterCode = Code(
            kind: .master(isHidden: true),
            pegs: Array(repeating: Code.missingPeg, count: masterCode.count)
        )
        self.guess = Code(
            kind: .guess,
            pegs: Array(repeating: Code.missingPeg, count: masterCode.count)
        )

        self.masterCode.word = masterCode
    }

    var attempts: [Code] {
        return _attempts.sorted { $0.timestamp < $1.timestamp }
    }

    func restart(with newMasterCode: String) {
        self.masterCode = Code(
            kind: .master(isHidden: true),
            pegs: Array(repeating: Code.missingPeg, count: newMasterCode.count)
        )
        self.guess = Code(
            kind: .guess,
            pegs: Array(repeating: Code.missingPeg, count: newMasterCode.count)
        )

        self.masterCode.word = newMasterCode

        _attempts.removeAll()

        isOver = false
    }

    func attemptGuess() {
        if !validGuess() {
            return
        }

        lastAttemptTime = .now

        let attempt = Code(
            kind: .attempt(guess.match(against: masterCode)),
            pegs: guess.pegs
        )

        _attempts.append(attempt)

        guess = Code(
            kind: .guess,
            pegs: Array(repeating: Code.missingPeg, count: guess.pegs.count)
        )

        if attempts.last?.pegs == masterCode.pegs {
            isOver = true
            masterCode.kind = .master(isHidden: false)
        }
    }

    func validGuess() -> Bool {
        if guess.pegs.allSatisfy({ $0 == Code.missingPeg }) || attempts.contains(where: { $0.pegs == guess.pegs }) {
            return false
        }

        return true
    }

    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
}
