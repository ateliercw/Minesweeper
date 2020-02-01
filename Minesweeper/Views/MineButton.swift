//
//  MineButton.swift
//  Minesweeper
//
//  Created by Michael Skiba on 27/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import SwiftUI

struct MineButton: View {
    let gridState: GridState
    let status: GameState.Status
    let reveal: () -> Void
    let flag: () -> Void
    let probe: () -> Void

    private var revealOrProbe: () -> Void {
        let action = { [gridState, reveal, probe] in
            if gridState.state == .revealed {
                probe()
            } else {
                reveal()
            }
        }
        return action
    }

    var body: some View {
        Button(action: revealOrProbe) {
            Text(gridState.label(status: status)).bold()
        }
        .buttonStyle(MineButtonConfiguration(gridState: gridState))
        .highPriorityGesture(TapGesture().modifiers(.option).onEnded(flag))
    }
}

struct MineButtonConfiguration: ButtonStyle {
    let gridState: GridState

    func opacity(configuration: Self.Configuration) -> Double {
        configuration.isPressed ? 0.3 : 1
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            if gridState.state != .revealed {
                Overlay()
            }
            configuration.label
        }
        .foregroundColor(gridState.textColor)
        .frame(width: 30, height: 30)
        .background(gridState.backgroundColor.opacity(opacity(configuration: configuration)))
    }
}

struct Overlay: View {
    private let gradientWidth: CGFloat = 2
    private let gradientOpacity: Double = 0.3
    private let lightGradient = Gradient(colors: [
        Color(Asset.Gradient.light),
        Color(Asset.Gradient.light).opacity(0)
    ])
    private let darkGradient = Gradient(colors: [
        Color(Asset.Gradient.dark),
        Color(Asset.Gradient.dark).opacity(0)
    ])

    var body: some View {
        GeometryReader { [gradientWidth, lightGradient, darkGradient, gradientOpacity] proxy in
            ZStack {
                LinearGradient(gradient: lightGradient,
                               startPoint: .top,
                               endPoint: .bottom)
                    .frame(width: proxy.size.width, height: gradientWidth)
                    .position(x: proxy.size.width / 2, y: gradientWidth / 2)
                    .opacity(gradientOpacity)
                LinearGradient(gradient: lightGradient,
                               startPoint: .leading,
                               endPoint: .trailing)
                    .frame(width: gradientWidth, height: proxy.size.height)
                    .position(x: gradientWidth / 2, y: proxy.size.height / 2)
                    .opacity(gradientOpacity)
                LinearGradient(gradient: darkGradient,
                               startPoint: .bottom,
                               endPoint: .top)
                    .frame(width: proxy.size.width, height: gradientWidth)
                    .position(x: proxy.size.width / 2, y: proxy.size.height - (gradientWidth / 2))
                    .opacity(gradientOpacity)
                LinearGradient(gradient: darkGradient,
                               startPoint: .trailing,
                               endPoint: .leading)
                    .frame(width: gradientWidth, height: proxy.size.height)
                    .position(x: proxy.size.width - (gradientWidth / 2), y: proxy.size.height / 2)
                    .opacity(gradientOpacity)
            }
        }
    }
}

private extension GridState {
    var backgroundColor: Color {
        state == .revealed ?
            Color(Asset.Mine.revealed) :
            Color(Asset.Mine.unrevealed)
    }

    var textColor: Color {
        let color: ColorAsset
        switch self.info {
        case .empty, .mine: color = Asset.label
        case .count(let count):
            switch count {
            case 1: color = Asset.Mine.Colors.mine1
            case 2: color = Asset.Mine.Colors.mine2
            case 3: color = Asset.Mine.Colors.mine3
            case 4: color = Asset.Mine.Colors.mine4
            case 5: color = Asset.Mine.Colors.mine5
            case 6: color = Asset.Mine.Colors.mine6
            case 7: color = Asset.Mine.Colors.mine7
            case 8: color = Asset.Mine.Colors.mine8
            default: color = Asset.label
            }
        }
        return Color(color)
    }
}

struct MineButton_Previews: PreviewProvider {
    static var previews: some View {
        MineButton(gridState: GridState(state: .flagged, info: .mine),
                   status: .active,
                   reveal: {},
                   flag: {},
                   probe: {})
    }
}
