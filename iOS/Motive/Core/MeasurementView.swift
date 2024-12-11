//
//  MeasurementView.swift
//  Motive
//
//  Created by Cem Kupeli on 10/16/24.
//

import SwiftUI

struct MeasurementView: View {
    @StateObject var userDataManager: UserDataManager
    @State private var xPosition: Double = 0
    @State private var yPosition: Double = 0
    @State private var sliderValue: Double = 4
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showConfirmationAlert = false
    
    private var motivationLabels = [
        "1 - Very unmotivated",
        "2 - Unmotivated",
        "3 - Somewhat unmotivated",
        "4 - Neutral",
        "5 - Somewhat motivated",
        "6 - Motivated",
        "7 - Very motivated",
    ]
    private let type: PromptType
    
    init(userDataManager: UserDataManager, type: PromptType) {
        self._userDataManager = StateObject(wrappedValue: userDataManager)
        self.type = type
    }

    var body: some View {
        ScrollView {
            Text(type == .pre ? "Pre-workout Report" : "Post-workout Report")
                .padding(.top, 40)
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            Text("Indicate your **\(type == .pre ? "predicted" : "current")** emotional state on the graph below\(type == .pre ? " (i.e. how do you think you will feel after this workout?)" : "").")
                .padding()
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            // Graph area with touch interaction for the dARM measure
            ZStack {
                GeometryReader { geometry in
                    let graphSize = geometry.size

                    // Coordinate plane
                    Rectangle()
                        .stroke(Color.gray, lineWidth: 1)
                        .background(Color.white)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let location = value.location

                                    let (x, y) = touchLocationToGraphCoordinates(location: location, graphSize: graphSize)
                                    xPosition = min(max(x, -250), 250)
                                    yPosition = min(max(y, -250), 250)
                                }
                        )

                    Axes()
                        .stroke(Color.black, lineWidth: 2)

                    // Selected point indicator
                    Circle()
                        .fill(Color.red)
                        .frame(width: 10, height: 10)
                        .position(graphCoordinatesToViewPosition(x: xPosition, y: yPosition, graphSize: graphSize))
                }
                .frame(width: 300, height: 300)
            }
            // Add the axis labels as overlays to keep the graph in place
            .overlay(
                // y-axis label
                Text("**Arousal (Alertness)**")
                    .rotationEffect(.degrees(-90))
                    .offset(x: -170)
                , alignment: .center
            )
            .overlay(
                // x-axis label
                Text("**Valence (Pleasurableness)**")
                    .padding(.top, 0)
                    .offset(y: 170)
                , alignment: .center
            )
            .frame(width: 300, height: 300)
            

            Text("Valence: \(Int(xPosition)), Arousal: \(Int(yPosition))")
                .padding(.top, 30)
            
            Text("How motivated are you to keep exercising? (1-7)")
                .padding(.top, 50)
            
            Slider(
                value: $sliderValue,
                in: 1...7,
                step: 1
            )
            .padding(.horizontal, 40)
            
            Text(motivationLabels[Int(sliderValue) - 1])
                .padding(.top, 10)
            
            Button {
                showConfirmationAlert = true
            } label: {
                Text("Save")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
            
            Spacer()
        }
        .alert("Confirm Submission", isPresented: $showConfirmationAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Submit", role: .destructive) {
                userDataManager.setMeasurements(type: type, measurements: [xPosition, yPosition, sliderValue])
                dismiss()
            }
        } message: {
            Text("""
            Are you sure you want to submit?

            Valence: \(round(xPosition))
            Arousal: \(round(yPosition))
            Motivation: \(round(sliderValue))
            """)
        }
    }

    // Convert touch location to graph coordinates
    private func touchLocationToGraphCoordinates(location: CGPoint, graphSize: CGSize) -> (x: Double, y: Double) {
        let x = Double(location.x / graphSize.width) * 500 - 250
        let y = Double((graphSize.height - location.y) / graphSize.height) * 500 - 250
        return (x, y)
    }

    // Convert graph coordinates to position on view
    private func graphCoordinatesToViewPosition(x: Double, y: Double, graphSize: CGSize) -> CGPoint {
        let xPos = CGFloat((x + 250) / 500) * graphSize.width
        let yPos = CGFloat((250 - y) / 500) * graphSize.height
        return CGPoint(x: xPos, y: yPos)
    }
}

// Helper shape to draw axes at the center of the graph
private struct Axes: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let centerX = rect.width / 2
        let centerY = rect.height / 2

        // Vertical axis (y-axis)
        path.move(to: CGPoint(x: centerX, y: 0))
        path.addLine(to: CGPoint(x: centerX, y: rect.height))

        // Horizontal axis (x-axis)
        path.move(to: CGPoint(x: 0, y: centerY))
        path.addLine(to: CGPoint(x: rect.width, y: centerY))

        return path
    }
}

#Preview {
    MeasurementView(userDataManager: UserDataManager(), type: .pre)
}
