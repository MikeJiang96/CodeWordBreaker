//
//  QwertyKeyboardView.swift
//  CodeWordBreaker
//
//  Created by Mike Jiang on 2026/1/13.
//

import SwiftUI

struct QwertyKeyboardView: View {
    let onKeyPress: (String) -> Void

    private let rows: [[String]] = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["Z", "X", "C", "V", "B", "N", "M"],
    ]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 6) {
                    ForEach(row, id: \.self) { letter in
                        KeyButton(letter: letter) {
                            onKeyPress(letter)
                        }
                    }
                }
            }
        }
        .padding()
        .aspectRatio(10.0 / 3.0, contentMode: .fit)
    }
}

struct KeyButton: View {
    let letter: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(letter)
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.gray.opacity(0.2))
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    QwertyKeyboardView { print($0) }
}
