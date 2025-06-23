//
//  AddSubscView.swift
//  SubscriptionManagementApp
//
//  Created by Engineer MacBook Air on 2025/06/21.
//

import SwiftUI
import RealmSwift

enum FrequencyPicker: String, CaseIterable {
    case yearly = "年額"
    case monthly = "月額"
    case oneTime = "買い切り"
}

struct AddSubscView: View {
    
    var itemToEdit: SubscriptionModel?
    
    @Binding var subscName: String
    @Binding var amount: Int?
    @Binding var paymentDate: Date?
    @Binding var cancelDate: Date?
    @Binding var frequency: FrequencyPicker
    @Binding var memo: String?
    @Binding var startDate: Date?
    var addSubscription: () -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("サブスクリプション名", text: $subscName)
                    .textFieldStyle(.roundedBorder)
                
                TextField("金額", value: $amount, formatter: NumberFormatter())
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                
                DatePicker("Payment Date",
                                selection: Binding(
                                    get: { paymentDate ?? Date() },
                                    set: { paymentDate = $0 }
                                ),
                                displayedComponents: .date
                )
                .environment(\.locale, Locale(identifier: "ja_JP"))
                
                DatePicker("Cancel Date",
                                selection: Binding(
                                    get: { cancelDate ?? Date() },
                                    set: { cancelDate = $0 }
                                ),
                                displayedComponents: .date
                )
                .environment(\.locale, Locale(identifier: "ja_JP"))
                
                Picker("頻度", selection: $frequency) {
                    ForEach(FrequencyPicker.allCases, id: \.self) { picker in
                        Text(picker.rawValue)
                    }
                }
                .pickerStyle(.menu)
                
                TextEditor(
                    text: Binding(
                        get: { memo ?? "" },
                        set: { memo = $0 }
                    )
                )
                .border(Color.red, width: 1)
                
                DatePicker("Start Date",
                                selection: Binding(
                                    get: { startDate ?? Date() },
                                    set: { startDate = $0 }
                                ),
                                displayedComponents: .date
                )
                .environment(\.locale, Locale(identifier: "ja_JP"))
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical)
            .navigationTitle(itemToEdit == nil ? "新規追加" : "編集")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let item = itemToEdit {
                    subscName = item.subscName
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル", role: .cancel) {
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
    AddSubscView(subscName: .constant("Previewだよ"), amount: .constant(100), paymentDate: .constant(Date()), cancelDate: .constant(Date()), frequency: .constant(.yearly), memo: .constant("メモだよ"), startDate: .constant(Date()), addSubscription: {})
}
