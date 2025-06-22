//
//  AddSubscView.swift
//  SubscriptionManagementApp
//
//  Created by Engineer MacBook Air on 2025/06/21.
//

import SwiftUI
import RealmSwift

struct AddSubscView: View {
    
    @ObservedResults(SubscriptionModel.self) var subscriptionModel

    @Binding var subscName: String
    
    var addSubscription: () -> Void
    
    var body: some View {
        VStack {
            Button(action: {
                addSubscription()
            }) {
                Image(systemName: "plus")
            }
            TextField("name", text: $subscName)
                .textFieldStyle(.roundedBorder)
                .onAppear {
                    if let specificItem = subscriptionModel.first(where: { $0.subscName == subscName }) {
                        subscName = specificItem.subscName
                    } else {
                        subscName = ""
                    }
                }
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
}

#Preview {
    AddSubscView(subscName: .constant("サブスクの名前だよ"), addSubscription: {})
}
