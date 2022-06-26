//
//  SwiftUI_NewsAppApp.swift
//  SwiftUI-NewsApp-Watch WatchKit Extension
//
//  Created by Park Sungmin on 2022/06/25.
//

import SwiftUI

@main
struct SwiftUI_NewsAppApp: App {
    
    @StateObject private var bookmarkVM = ArticleBookmarkViewModel.shared
    @StateObject private var searchVM = ArticleSearchViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(bookmarkVM)
            .environmentObject(searchVM)
        }
    }
}
