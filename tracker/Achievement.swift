//
//  Achievement.swift
//  tracker3
//
//  Created by Sophie Evans on 5/16/23.
//

import Foundation

struct Achievement: Codable, Identifiable {
    var id = UUID()
    let name: String
    let desc: String
    var done: Bool
    let category: String
    
    private enum CodingKeys: String, CodingKey {
        case name, desc, done, category
    }
}

struct Achievements: Codable {
    let achievements: [Achievement]
    
    private enum CodingKeys: String, CodingKey {
        case achievements
    }
}

struct CategoryAchievements: Identifiable {
    let id = UUID()
    let category: String
    let achievements: [Achievement]
    let subcategories: [String: [Achievement]]
    var doneCount: Int {
        achievements.filter { $0.done }.count
    }
}
