//
//  ContentView.swift
//  Golf
//
//  Created by IIT PHYS 440 on 2/24/23.
//

import SwiftUI

struct GolfChippingView: View {
    
    @State private var ballPosition: CGPoint = CGPoint(x: 100, y: 500)
    @State private var holePosition: CGPoint = CGPoint(x: 300, y: 300)
    @State private var isHoleReached = false
    
    var body: some View {
        GeometryReader { geometry in
            let greenRect = CGRect(x: 0, y: 0, width: geometry.size.width, height: geometry.size.height)
            VStack {
                Canvas { context, size in
                    // Draw the green
                    context.stroke(Path(roundedRect: greenRect, cornerRadius: 10), with: .color(Color.green), lineWidth: 10)
                    
                    // Draw the hole
                    context.fill(Path(ellipseIn: CGRect(x: holePosition.x - 10, y: holePosition.y - 10, width: 20, height: 20)), with: .color(Color.black))
                    
                    // Draw the ball
                    context.fill(Path(ellipseIn: CGRect(x: ballPosition.x - 10, y: ballPosition.y - 10, width: 20, height: 20)), with: .color(Color.blue))
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let newBallPosition = CGPoint(x: value.location.x, y: value.location.y)
                            if greenRect.contains(newBallPosition) {
                                ballPosition = newBallPosition
                            }
                        }
                        .onEnded { _ in
                            if !isHoleReached {
                                let distance = ballPosition.distance(to: holePosition)
                                if distance <= 30 {
                                    isHoleReached = true
                                    ballPosition = holePosition
                                } else {
                                    let angle = Double.random(in: 0..<Double.pi * 2)
                                    let dx = cos(angle) * distance / 10
                                    let dy = sin(angle) * distance / 10
                                    let newBallPosition = CGPoint(x: ballPosition.x + CGFloat(dx), y: ballPosition.y + CGFloat(dy))
                                    ballPosition = newBallPosition
                                }
                            }
                        }
                )
                
                if isHoleReached {
                    Text("You made it!")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> Double {
        let dx = Double(point.x - self.x)
        let dy = Double(point.y - self.y)
        return sqrt(dx * dx + dy * dy)
    }
}

struct GolfChippingView_Previews: PreviewProvider {
    static var previews: some View {
        GolfChippingView()
    }
}
