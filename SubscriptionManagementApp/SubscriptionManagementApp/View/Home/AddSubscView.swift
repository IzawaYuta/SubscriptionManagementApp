//
//  AddSubscView.swift
//  SubscriptionManagementApp
//
//  Created by Engineer MacBook Air on 2025/06/21.
//

import SwiftUI

struct AddSubscView: View {
    
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
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
}

#Preview {
    AddSubscView(subscName: .constant("サブスクの名前だよ"), addSubscription: {})
}
