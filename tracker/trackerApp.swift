//
//  trackerApp.swift
//  tracker
//
//  Created by Sophie Evans on 5/16/23.
//

import SwiftUI

@main
struct trackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(DataModel()).preferredColorScheme(.dark).font(.custom("monofonto", size: 17))
        }
    }
}
