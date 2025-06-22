//
//  HomeView.swift
//  SubscriptionManagementApp
//
//  Created by Engineer MacBook Air on 2025/06/20.
//

import SwiftUI
import RealmSwift

import SwiftUI
import RealmSwift

struct HomeView: View {
    
    @ObservedResults(SubscriptionModel.self) var subscriptionModel
    
    @State private var subscName: String = ""
    @State private var showAddSubscView = false
    @State private var editSubscriptionModel: SubscriptionModel?
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    self.editSubscriptionModel = nil
                    self.subscName = ""
                    self.showAddSubscView = true
                }) {
                    Image(systemName: "plus")
                }
                .padding(.horizontal)
                
                List {
                    ForEach(subscriptionModel) { list in
                        Button(action: {
                            self.editSubscriptionModel = list
//                            self.subscName = list.subscName 
                            self.showAddSubscView = true
                        }) {
                            HStack {
                                Text(list.subscName)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.bold))
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                        }
                    }
                    .onDelete(perform: $subscriptionModel.remove)
                }
            }
            .navigationTitle("サブスクリプション")
            .sheet(isPresented: $showAddSubscView) {
                AddSubscView(
                    itemToEdit: self.editSubscriptionModel,
                    subscName: self.$subscName,
                    addSubscription: {
                        self.addSubscription()
                        self.showAddSubscView = false
                    }
                )
            }
        }
    }
    
    private func addSubscription() {
        let realm = try! Realm()
        
        if let editModel = editSubscriptionModel {
            guard let thawedModel = editModel.thaw() else { return }
            
            try! realm.write {
                thawedModel.subscName = self.subscName
            }
        }
        else {
            if !self.subscName.trimmingCharacters(in: .whitespaces).isEmpty {
                let model = SubscriptionModel()
                model.subscName = self.subscName
                try! realm.write {
                    realm.add(model)
                }
            }
        }
        self.subscName = ""
        self.editSubscriptionModel = nil
    }
}

#Preview {
    HomeView()
}
