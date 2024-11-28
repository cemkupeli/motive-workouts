//
//  IndicatorView.swift
//  Motive
//
//  Created by Cem Kupeli on 11/28/24.
//

import SwiftUI

struct Triangle: Shape {
    var pointingUp: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()

        if pointingUp {
            // Triangle pointing up
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        } else {
            // Triangle pointing down
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        }

        path.closeSubpath()
        return path
    }
}

struct IndicatorView: View {
    let difference: Double
    
    var body: some View {
        if difference > 0 {
            Triangle(pointingUp: true)
                .fill(Color.green)
        } else if difference < 0 {
            Triangle(pointingUp: false)
                .fill(Color.red)
        } else {
            Rectangle()
                .fill(Color.gray)
                .frame(height: 2)
        }
    }
}

#Preview {
    IndicatorView(difference: 2)
        .frame(width: 20, height: 20)
}
