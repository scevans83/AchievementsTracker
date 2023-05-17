//
//  DataModel.swift
//  tracker
//
//  Created by Sophie Evans on 5/16/23.
//

import Foundation

class DataModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    var groupedAchievements: [CategoryAchievements] {
        // Define your mapping from original categories to super categories.
        let superCategories: [String: String] = ["Institute": "Factions", "Minutemen": "Factions", "Railroad":"Factions", "Brotherhood of Steel": "Factions", "Automatron":"DLC","Far Harbor":"DLC","Nuka-World":"DLC","Contraptions Workshop":"DLC","Vault-Tec Workshop":"DLC","Wasteland Workshop":"DLC"]
        
        // Group the achievements by super category.
        let groupedByCategory = Dictionary(grouping: achievements) { achievement in
            superCategories[achievement.category] ?? achievement.category
        }
        
        // Group the achievements by original category within each super category.
        let groupedBySubcategory = groupedByCategory.mapValues { achievements in
            Dictionary(grouping: achievements, by: { $0.category })
        }
        
        return groupedBySubcategory.map { category, subcategories in
            let achievements = subcategories.values.flatMap { $0 }
            return CategoryAchievements(category: category, achievements: achievements, subcategories: subcategories)
        }
    }

    
    func loadJSON() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsURL.appendingPathComponent("AchievementsList.json")

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodedAchievements = try decoder.decode([Achievement].self, from: data)
            self.achievements = decodedAchievements
        } catch {
            print("Error reading file: \(error)")
        }
    }



    func saveJSON() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let data = try encoder.encode(achievements)
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documentsURL.appendingPathComponent("AchievementsList.json")
            try data.write(to: url)
        } catch {
            print("Error encoding achievements or writing JSON: \(error)")
        }
    }

    
    func copyJSONFirst() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsURL.appendingPathComponent("AchievementsList.json")
        
        guard !fileManager.fileExists(atPath: destinationURL.path) else {
            // The file already exists, so we don't need to copy it.
            return
        }
        
        guard let sourceURL = Bundle.main.url(forResource: "AchievementsList", withExtension: "json") else {
            print("Source file not found.")
            return
        }
        
        do {
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
            print("AchievementsList.json copied to Documents folder.")
        } catch {
            print("Could not copy file: \(error)")
        }
    }

}
