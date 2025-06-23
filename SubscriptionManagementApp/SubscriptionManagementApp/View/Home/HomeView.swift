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
    @State private var editSubscriptionModel: SubscriptionModel?
    
    @State private var subscName: String = ""
    @State private var amount: Int? = nil
    @State private var paymentDate: Date?
    @State private var cancelDate: Date?
    @State private var frequency: FrequencyPicker = .yearly
    @State private var memo: String?
    @State private var startDate: Date?
    @State private var showAddSubscView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("合計: ")
                    Text("\(subscriptionModel.compactMap { $0.amount ?? 0 }.reduce(0, +)) 円")
                        .fontWeight(.bold)
                }
                .padding(.top)
                
                Button(action: {
                    self.editSubscriptionModel = nil
                    self.subscName = ""
                    self.amount = nil
                    self.paymentDate = nil
                    self.cancelDate = nil
                    self.frequency = .yearly
                    self.memo = nil
                    self.startDate = nil
                    self.showAddSubscView = true
                }) {
                    Image(systemName: "plus")
                }
                .padding(.horizontal)
                
                List {
                    ForEach(subscriptionModel) { list in
                        Button(action: {
                            self.editSubscriptionModel = list
                            self.subscName = list.subscName
                            self.amount = list.amount
                            self.paymentDate = list.paymentDate
                            self.cancelDate = list.cancelDate
                            self.frequency = FrequencyPicker(rawValue: list.frequency) ?? .yearly
                            self.memo = list.memo
                            self.startDate = list.startDate
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
                    subscName: self.$subscName, amount: self.$amount, paymentDate: self.$paymentDate, cancelDate: $cancelDate, frequency: $frequency, memo: $memo, startDate: $startDate,
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
                thawedModel.amount = self.amount
                thawedModel.paymentDate = self.paymentDate
                thawedModel.cancelDate = self.cancelDate
                thawedModel.frequency = self.frequency.rawValue
                thawedModel.memo = self.memo
                thawedModel.startDate = self.startDate
            }
        }
        else {
            if !self.subscName.trimmingCharacters(in: .whitespaces).isEmpty {
                let model = SubscriptionModel()
                model.subscName = self.subscName
                model.amount = self.amount
                model.paymentDate = self.paymentDate
                model.cancelDate = self.cancelDate
                model.frequency = self.frequency.rawValue
                model.memo = self.memo
                model.startDate = self.startDate
                try! realm.write {
                    realm.add(model)
                }
            }
        }
        self.subscName = ""
        self.amount = nil
        self.paymentDate = nil
        self.cancelDate = nil
        self.frequency = .yearly
        self.memo = nil
        self.startDate = nil
        self.editSubscriptionModel = nil
    }
}

#Preview {
    HomeView()
}
