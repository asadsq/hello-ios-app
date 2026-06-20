//
//  ContentView.swift
//  hello-ios-app
//
//  Created by Asad Saleem Qureshi on 6/7/26.
//

import SwiftUI

struct ContentView: View {
    @State private var phraseIndex: Int = 0
    @State private var meshPhase: CGFloat = 0

    private let phrases: [String] = [
        "let's build",
        "آؤ بنائیں",
        "一起建造"
    ]

    private let cream = Color(red: 0.96, green: 0.92, blue: 0.84)
    private let peach = Color(red: 0.96, green: 0.83, blue: 0.69)
    private let coral = Color(red: 0.86, green: 0.47, blue: 0.34)
    private let warmTan = Color(red: 0.89, green: 0.76, blue: 0.58)
    private let inkBrown = Color(red: 0.15, green: 0.10, blue: 0.07)

    private var meshPoints: [SIMD2<Float>] {
        let p = Float(meshPhase)
        return [
            [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
            [0.0, 0.5], [0.4 + 0.2 * p, 0.45 + 0.1 * p], [1.0, 0.5],
            [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
        ]
    }

    var body: some View {
        ZStack {
            MeshGradient(
                width: 3,
                height: 3,
                points: meshPoints,
                colors: [
                    peach, cream, warmTan,
                    cream, peach, coral.opacity(0.6),
                    warmTan, coral.opacity(0.7), peach
                ]
            )
            .ignoresSafeArea()

            Text(phrases[phraseIndex])
                .font(.system(size: 72, weight: .semibold, design: .serif))
                .foregroundStyle(inkBrown)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.6)
                .lineLimit(2)
                .padding(.horizontal, 32)
                .transition(.opacity)
                .id(phraseIndex)
        }
        .task {
            withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                meshPhase = 1
            }
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(2.5))
                withAnimation(.easeInOut(duration: 0.9)) {
                    phraseIndex = (phraseIndex + 1) % phrases.count
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
