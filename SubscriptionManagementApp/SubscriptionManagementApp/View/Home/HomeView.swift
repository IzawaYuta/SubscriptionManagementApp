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
    
    @State private var tap = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    List {
                        Section {
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
                        } header: {
                            HStack {
                                HStack {
                                    Text("合計: ")
                                        .font(.system(size: 25))
                                    Text("\(subscriptionModel.compactMap { $0.amount ?? 0 }.reduce(0, +)) 円")
                                        .font(.system(size: 25))
                                }
                                .padding(.top)
                                
                                Spacer()
                                
                                
                            }
                        }
                    }
                }
                //                .navigationTitle("サブスクリプション")
                .sheet(isPresented: $showAddSubscView) {
                    AddSubscView(
                        itemToEdit: self.editSubscriptionModel,
                        subscName: self.$subscName, amount: self.$amount, paymentDate: self.$paymentDate, cancelDate: $cancelDate, frequency: $frequency, memo: $memo, startDate: $startDate,
                        addSubscription: {
                            self.addSubscription()
                            self.showAddSubscView = false
                        },
                        dismisCancelButton: { self.tap = false }
                    )
                }
                GeometryReader { geometry in
                    ZStack {
                        ZStack {
                            // アニメーション対象の RoundedRectangle
                            RoundedRectangle(cornerRadius: 15)
                                .fill(tap ? .clear : .cyan.opacity(0.5))
                            Image(systemName: "plus")
                        }
                        
                        AddSubscView(
                            itemToEdit: self.editSubscriptionModel,
                            subscName: self.$subscName,
                            amount: self.$amount,
                            paymentDate: self.$paymentDate,
                            cancelDate: $cancelDate,
                            frequency: $frequency,
                            memo: $memo,
                            startDate: $startDate,
                            addSubscription: {
                                self.addSubscription()
                                self.showAddSubscView = false
                            },
                            dismisCancelButton: { self.tap = false}
                        )
                        .background(Color.white)
                        .cornerRadius(15)
                        .opacity(tap ? 1.0 : 0.0) // 1. if文の代わりにopacityで表示を制御
                        .clipped()               // 2. 縮小時に中身がはみ出ないようにする
                    }
                    .frame(width: tap ? geometry.size.width * 0.95 : 50,
                           height: tap ? geometry.size.height * 0.97 : 50)
                    .position(
                        x: tap ? geometry.size.width / 2 : geometry.size.width - 50,
                        y: tap ? geometry.size.height / 2 : 20
                    )
                    .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3), value: tap)
                    .onTapGesture {
                        withAnimation {
                            tap.toggle()
                        }
                    }
                }
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
