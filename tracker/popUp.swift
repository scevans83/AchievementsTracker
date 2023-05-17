//
//  popUp.swift
//  tracker
//
//  Created by Sophie Evans on 5/16/23.
//

import Foundation
import SwiftUI

extension Color {
    static let bright = Color(red: 7/255, green: 238/255, blue: 0/255)
    static let dark = Color(red: 1/255, green: 95/255, blue: 0/255)
}

struct popUp: View {
    @EnvironmentObject var viewModel: DataModel
    @Binding var achievement: Achievement
    
    var body: some View {
        VStack {
            Text(achievement.name)
            Text(achievement.desc)
            Toggle(isOn: $achievement.done) {
                Text(achievement.done ? "Done" : "Not Done")
            }.onChange(of: achievement.done) { _ in
                viewModel.saveJSON()
            }

            .padding()
        }
        .background(Color.black)
    }
}

struct popUp_Previews: PreviewProvider {
    static var previews: some View {
        let achievement = Achievement(name: "Example Achievement", desc: "This is an example achievement", done: false, category: "test")
        let viewModel = DataModel()

        return popUp(achievement: .constant(achievement))
            .environmentObject(viewModel)
    }
}

