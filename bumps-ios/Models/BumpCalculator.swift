//
//  BumpCalculator.swift
//  bumps-ios
//
//  Created by Matt Dyor on 8/23/24.
//

import Foundation

class BumpCalculator {
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
            
            return golferBumps
        }
     
}
