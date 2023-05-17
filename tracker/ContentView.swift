//
//  ContentView.swift
//  tracker
//
//  Created by Sophie Evans on 5/16/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: DataModel
    @State private var selectedAchievement: Achievement?
    @State private var selectedTab = "home"

    var body: some View {
        VStack {
            HStack {
                Group {
                    Spacer()
                    CustomButton(title: "Factions", selectedView: $selectedTab)
                    Spacer()
                    CustomButton(title: "Main", selectedView: $selectedTab)
                    Spacer()
                    CustomButton(title: "Home", selectedView: $selectedTab)
                    Spacer()
                }
                CustomButton(title: "General", selectedView: $selectedTab)
                Spacer()
                CustomButton(title: "DLC", selectedView: $selectedTab)
                Spacer()
            }
            .padding()
            .background(Color.black)
            
            Spacer()

            switch selectedTab {
            case "factions":
                AchievementListView(categories: ["Institute", "Minutemen", "Railroad", "Brotherhood of Steel"])
            case "main":
                AchievementListView(categories: ["Main"])
            case "home":
                HomeView()
            case "general":
                AchievementListView(categories: ["General"])
            case "dlc":
                AchievementListView(categories: ["Automatron","Far Harbor","Nuka-World","Contraptions Workshop","Vault-Tec Workshop","Wasteland Workshop"])
            default:
                EmptyView()
            }
        }
    }
}

struct CustomButton: View {
    var title: String
    @Binding var selectedView: String

    var body: some View {
        Button(action: {
            selectedView = title.lowercased()
        }) {
            Text(title)
                .foregroundColor(selectedView == title.lowercased() ? .bright : .dark)
                .font(.custom("monofonto", size: 19))
        }
    }
}

struct AchievementListView: View {
    @EnvironmentObject var viewModel: DataModel
    @State private var selectedAchievement: Achievement?
    let categories: [String]

    var body: some View {
        List {
            ForEach(categories, id: \.self) { category in
                Section(header: Text(category).font(.custom("monofonto", size: 25))) {
                    ForEach(viewModel.achievements.filter { $0.category == category }) { achievement in
                        VStack(alignment: .leading) {
                            Text(achievement.name)
                                .foregroundColor(achievement.done ? .dark : .bright)
                                .font(.custom("monofonto", size: 20))
                            Text(achievement.desc)
                                .foregroundColor(achievement.done ? .dark : .bright)
                            //Text(achievement.done ? "Done" : "Not Done")
                             //   .foregroundColor(achievement.done ? .dark : .bright)
                        }
                        .onTapGesture {
                            self.selectedAchievement = achievement
                        }
                    }
                }
            }.listRowBackground(Color.black)
        }
        .scrollContentBackground(.hidden)
        .onAppear {
            viewModel.copyJSONFirst()
            viewModel.loadJSON()
        }
        .sheet(item: $selectedAchievement, onDismiss: {
            selectedAchievement = nil
        }) { achievement in
            popUp(achievement: $viewModel.achievements.first(where: { $0.id == achievement.id })!)
        }
        .background(Color.black) // Set the background color to black
        .foregroundColor(.bright) // Set the text and icons color
        .font(.custom("monofonto", size: 15))
        .scrollContentBackground(.hidden)
    }
}




struct HomeView: View {
    var body: some View {
        Text("Welcome to the app!")
            .font(.custom("monofonto", size: 40))
            .foregroundColor(.bright)
            .background(Color.black)

    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(DataModel())
    }
}
