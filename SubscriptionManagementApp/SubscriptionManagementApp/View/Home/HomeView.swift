//
//  HomeView.swift
//  SubscriptionManagementApp
//
//  Created by Engineer MacBook Air on 2025/06/20.
//

import SwiftUI
import RealmSwift

struct HomeView: View {
    
    @ObservedResults(SubscriptionModel.self) var subscriptionModel
    
    @State private var subscName: String = ""
    @State var showAddSubscView = false
    
    var body: some View {
        VStack {
            HStack {
                TextField("name", text: $subscName)
                Button(action: {
                    showAddSubscView.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $showAddSubscView) {
                    AddSubscView(
                        subscName: $subscName,
                        addSubscription: {
                            addSubscription()
                            showAddSubscView = false
                        })
                }
            }
            .padding(.horizontal)
            
            List {
                ForEach(subscriptionModel, id: \.id) { list in
                    Text(list.subscName)
                }
            }
        }
    }
    
    private func addSubscription() {
        let realm = try! Realm()
        try! realm.write {
            let model = SubscriptionModel()
            model.subscName = subscName
            realm.add(model)
        }
        subscName = ""
    }
}

#Preview {
    HomeView()
}
