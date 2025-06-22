//
//  AddSubscView.swift
//  SubscriptionManagementApp
//
//  Created by Engineer MacBook Air on 2025/06/21.
//

import SwiftUI
import RealmSwift

struct AddSubscView: View {
    
    var itemToEdit: SubscriptionModel?
    
    @Binding var subscName: String
    var addSubscription: () -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("サブスクリプション名", text: $subscName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Spacer()
            }
            .navigationTitle(itemToEdit == nil ? "新規追加" : "編集")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let item = itemToEdit {
                    subscName = item.subscName
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        addSubscription()
                    }
                    .disabled(subscName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddSubscView(subscName: .constant("Previewだよ"), addSubscription: {})
}
