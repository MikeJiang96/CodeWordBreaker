//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 4/30/25.
//

import SwiftData
import SwiftUI

struct GameChooser: View {
    // MARK: Data Owned by Me
    @State
    private var selection: CodeWordBreaker? = nil

    @State
    private var filterOption: GameList.FilterOption = .none

    @State
    private var search: String = ""

    // MARK: - Body

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            Picker("Filter By", selection: $filterOption.animation(.default)) {
                ForEach(GameList.FilterOption.allCases, id: \.self) { option in
                    Text(option.title)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            GameList(filterBy: filterOption, masterCodeOrAttemptsContains: search, selection: $selection)
                .navigationTitle("CodeWord Breaker")
                .searchable(text: $search)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .animation(.easeOut, value: search)
        } detail: {
            if let selection {
                CodeWordBreakerView(game: selection)
                    .navigationTitle(selection.name)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Choose a game!")
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    let memoryStoreOnly = true
    let memoryStoreOnlyPreviewFlag = { memoryStoreOnly }()

    // FIXME: Trick to suppress compiler warnings
    if memoryStoreOnlyPreviewFlag {
        let container = try! ModelContainer(
            for: CodeWordBreaker.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        let defaults = UserDefaults.standard
        if let bundleID = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundleID)
        }

        return GameChooser()
            .modelContainer(container)
    } else {
        let container = try! ModelContainer(
            for: CodeWordBreaker.self
        )

        return GameChooser()
            .modelContainer(container)
    }
}
