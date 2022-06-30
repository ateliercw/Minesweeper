//
//  SettingsView.swift
//  Minesweeper
//
//  Created by Michael Skiba on 21/06/2022.
//

import SwiftUI

struct SettingsView: View {
    @Binding var width: Int
    @Binding var height: Int
    @Binding var mines: Int

    @Environment(\.dismiss) var dismiss

    private var maxMines: Int {
        (width * height) - 1
    }

    var body: some View {
        Form {
            difficultySection
            customSection
        }
        .onChange(of: width * height) { _ in
            updateMineCount()
        }
        .monospacedDigit()
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Done") { dismiss() }
            }
        }
    }
}

private extension SettingsView {
    var difficultySection: some View {
        Section("Difficulty") {
            ForEach(Difficulty.allCases) { difficulty in
                Button(difficulty.label) {
                    apply(difficulty)
                }
            }
        }
    }

    var customSection: some View {
        Section("Custom") {
            LabelSlider(value: $width, label: "Width:", range: 9...32)
            LabelSlider(value: $height, label: "Height:", range: 9...32)
            LabelSlider(value: $mines, label: "Mines:", range: 5...maxMines)
        }
    }

    func apply(_ difficulty: Difficulty) {
        width = difficulty.width
        height = difficulty.height
        mines = difficulty.mineCount
    }

    func updateMineCount() {
        mines = min(maxMines, mines)
    }
}

// MARK: - LabelSlider
private struct LabelSlider: View {
    @Binding var value: Int
    let label: String
    let range: ClosedRange<Int>

    var body: some View {
        LabeledContent(label) {
            ZStack(alignment: .trailing) {
                Text("00").hidden()
                Text(value, format: .number)
            }
            Slider(value: $value.floatBinding, in: Float(range.lowerBound)...Float(range.upperBound)) {
                Text(value, format: .number)
            } minimumValueLabel: {
                Text(range.lowerBound, format: .number)
            } maximumValueLabel: {
                Text(range.upperBound, format: .number)
            }
        }
    }
}

// MARK: - Float -> Int Binding
extension Binding where Value == Int {
    var floatBinding: Binding<Float> {
        Binding<Float> {
            Float(wrappedValue)
        } set: {
            wrappedValue = Int($0)
        }
    }
}

// MARK: - Difficulty
private extension SettingsView {
    enum Difficulty: CaseIterable, Identifiable, Hashable {
        var id: Self { self }

        case easy
        case medium
        case expert

        var label: LocalizedStringKey {
            switch self {
            case .easy:
                return LocalizedStringKey("Easy")
            case .medium:
                return LocalizedStringKey("Medium")
            case .expert:
                return LocalizedStringKey("Expert")
            }
        }

        var width: Int {
            switch self {
            case .easy:
                return 9
            case .medium:
                return 16
            case .expert:
                return 30
            }
        }

        var height: Int {
            switch self {
            case .easy:
                return 9
            case .medium, .expert:
                return 16
            }
        }

        var mineCount: Int {
            switch self {
            case .easy:
                return 10
            case .medium:
                return 40
            case .expert:
                return 99
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(width: .constant(9), height: .constant(9), mines: .constant(10))
            .previewLayout(.sizeThatFits)
    }
}
