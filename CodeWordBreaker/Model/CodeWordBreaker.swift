//
//  CodeWordBreaker.swift
//  CodeWordBreaker
//
//  Created by Mike Jiang on 2026/1/11.
//

import Foundation

typealias Peg = String

@Observable
class CodeWordBreaker {
    var name: String
    var masterCode: Code
    var guess: Code
    var attempts = [Code]()
    let pegChoices: [Peg]
    var lastAttemptTime: Date?

    init(name: String = "CodeWord Breaker", masterCode: String = "DEFAULT") {
        pegChoices = "QWERTYUIOPASDFGHJKLZXCVBNM".map { String($0) }

        self.name = name
        self.masterCode = Code(kind: .master(isHidden: true), size: masterCode.count)
        self.guess = Code(kind: .guess, size: masterCode.count)

        self.masterCode.word = masterCode
        print(self.masterCode)
    }

    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }

    func restart(with newMasterCode: String) {
        self.masterCode = Code(kind: .master(isHidden: true), size: newMasterCode.count)
        self.masterCode.word = newMasterCode
        print(self.masterCode)

        guess = Code(kind: .guess, size: newMasterCode.count)
        attempts.removeAll()
    }

    func attemptGuess() {
        if !validGuess() {
            return
        }

        lastAttemptTime = .now

        var attemp = guess

        attemp.kind = .attempt(attemp.match(against: masterCode))
        attempts.append(attemp)

        guess = Code(kind: .guess, size: guess.pegs.count)

        if isOver {
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

extension CodeWordBreaker: Identifiable, Hashable, Equatable {
    static func == (lhs: CodeWordBreaker, rhs: CodeWordBreaker) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
