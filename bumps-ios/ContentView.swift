//
//  ContentView.swift
//  bumps-ios
//
//  Created by Matt Dyor on 8/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var golferName: String = ""
    @State private var golferBumps: String = ""
    @State private var golfers: [Golfer] = []
    @State private var bumpResults: [String: [Int]] = [:]
    @State private var bumpsCalculated: Bool = false
    
    // Holes with provided difficulty levels
    let holes: [Hole] = [
        Hole(number: 1, difficulty: 6),
        Hole(number: 2, difficulty: 8),
        Hole(number: 3, difficulty: 18),
        Hole(number: 4, difficulty: 10),
        Hole(number: 5, difficulty: 14),
        Hole(number: 6, difficulty: 12),
        Hole(number: 7, difficulty: 4),
        Hole(number: 8, difficulty: 16),
        Hole(number: 9, difficulty: 2),
        Hole(number: 10, difficulty: 11),
        Hole(number: 11, difficulty: 7),
        Hole(number: 12, difficulty: 17),
        Hole(number: 13, difficulty: 1),
        Hole(number: 14, difficulty: 13),
        Hole(number: 15, difficulty: 9),
        Hole(number: 16, difficulty: 5),
        Hole(number: 17, difficulty: 15),
        Hole(number: 18, difficulty: 3)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            if !bumpsCalculated {
                // Input section
                Text("Enter Golfer Details")
                    .font(.title)
                    .padding(.bottom, 10)
                
                TextField("Golfer Name", text: $golferName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                
                TextField("Handicap (Bumps)", text: $golferBumps)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(.bottom, 10)
                
                Button(action: {
                    addGolfer()
                }) {
                    Text("Add Golfer")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.bottom, 20)
                
                // List of golfers
                Text("Golfers Added:")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                List(golfers, id: \.name) { golfer in
                    GolferView(golfer: golfer)
                }
                
                // Calculate Bumps button
                Button(action: {
                    bumpResults = calculateBumps(golfers: golfers, holes: holes)
                }) {
                    Text("Calculate Bumps")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 20)
            }
            
            // Display Bump Results
            if bumpsCalculated && !bumpResults.isEmpty {
                Text("Bump Results:")
                    .font(.headline)
                    .padding(.top, 20)
                
                List(bumpResults.keys.sorted(), id: \.self) { golferName in
                    VStack(alignment: .leading) {
                        Text("\(golferName):")
                            .font(.subheadline)
                            .bold()
                        Text("Holes: \(bumpResults[golferName]?.map { String($0) }.joined(separator: ", ") ?? "")")
                    }
                }
            }
        }
        .padding()
    }
    
    // Add golfer to the list
    private func addGolfer() {
        if let bumps = Int(golferBumps), !golferName.isEmpty {
            let newGolfer = Golfer(name: golferName, bumps: bumps, wins: 0)
            golfers.append(newGolfer)
            golferName = ""
            golferBumps = ""
        }
    }
    
    // Calculate bumps using the BumpCalculator
    func calculateBumps(golfers: [Golfer], holes: [Hole]) -> [String: [Int]] {
        // Sort the holes by difficulty in ascending order
        let sortedHoles = holes.sorted { $0.difficulty < $1.difficulty }
        
        // Create a dictionary to hold the result
        var golferBumps: [String: [Int]] = [:]
        
        // Assign bumps for each golfer
        for golfer in golfers {
            let bumps = sortedHoles.prefix(golfer.bumps).map { $0.number }
            golferBumps[golfer.name] = Array(bumps)
        }
        bumpsCalculated = true
        return golferBumps
    }
}

struct GolferView: View {
    let golfer: Golfer
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Golfer: \(golfer.name)")
                .font(.headline)
            Text("Handicap (Bumps): \(golfer.bumps)")
            Text("Wins: \(golfer.wins)")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
