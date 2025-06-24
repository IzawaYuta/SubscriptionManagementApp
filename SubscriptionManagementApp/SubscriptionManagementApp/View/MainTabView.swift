//
//  MainTabView.swift
//  SubscriptionManagementApp
//
//  Created by Engineer MacBook Air on 2025/06/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("HomeView", systemImage: "plus") {
                HomeView()
            }
        }
    }
}

#Preview {
    MainTabView()
}
