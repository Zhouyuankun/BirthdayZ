//
//  AnimatedRingView.swift
//  Birthdaz
//
//  Created by 周源坤 on 2023/3/23.
//

import SwiftUI
import Foundation

struct AnimatedRingView: View {
    var ring: Ring
    @State var showRing: Bool = false
    var body: some View {
        ZStack {
            Circle()
                .stroke(.gray.opacity(0.3), lineWidth: 10)
            
            Circle()
                .trim(from: 0, to: ring.progress / 100)
                .trim(from: 0, to: showRing ? ring.progress / 100 : 0)
                .stroke(ring.keyColor, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(-90))
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.interactiveSpring(response: 1, dampingFraction: 1, blendDuration: 1)) {
                    showRing = true
                }
            }
        }
    }
}

struct Ring: Identifiable {
    var id = UUID().uuidString
    var progress: CGFloat
    var value: String
    var keyIcon: String
    var keyColor: Color
    var isText: Bool = false
}
