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
    @State private var tempPaymentDate: Date = Date() // 仮の日付
    @State private var add = false
    @State private var paymentDateView = false
    @Binding var cancelDate: Date?
    @State private var tempcancelDate: Date = Date() // 仮の日付
    @State private var cancelDateAdd = false
    @State private var cancelDateView = false
    @Binding var frequency: FrequencyPicker
    //    @Binding var memo: String?
    @Binding var startDate: Date?
    @State private var addMemo = false
    @State private var alert = false
    var addSubscription: () -> Void
    var dismisCancelButton: () -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("サブスクリプション名")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("", text: $subscName)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        Text("金額")
                        TextField("", value: $amount, formatter: NumberFormatter())
                            .frame(width: 120)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                    }
                    
                    if add == false {
                        HStack {
                            Text("お支払日")
                            
                            Spacer()
                            
                            Button(action: {
                                paymentDateView = true
                            }) {
                                Text("設定する")
                            }
                            .sheet(isPresented: $paymentDateView) {
                                paymentDateAddView()
                                
                            }
                        }
                    } else {
                        DatePicker("お支払日",
                                   selection: Binding(
                                    get: { paymentDate ?? Date() },
                                    set: { paymentDate = $0 }
                                   ),
                                   displayedComponents: .date
                        )
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                    }
                    
                    if cancelDateAdd == false {
                        HStack {
                            Text("解約日")
                            
                            Spacer()
                            
                            Button(action: {
                                cancelDateView = true
                            }) {
                                Text("設定する")
                            }
                            .sheet(isPresented: $cancelDateView) {
                                cancelDateAddView()
                                
                            }
                        }
                    } else {
                        DatePicker("解約日",
                                   selection: Binding(
                                    get: { cancelDate ?? Date() },
                                    set: { cancelDate = $0 }
                                   ),
                                   displayedComponents: .date
                        )
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                    }
                    
                    Picker("頻度", selection: $frequency) {
                        ForEach(FrequencyPicker.allCases, id: \.self) { picker in
                            Text(picker.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    DatePicker("開始日",
                               selection: Binding(
                                get: { startDate ?? Date() },
                                set: { startDate = $0 }
                               ),
                               displayedComponents: .date
                    )
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    
                    //                    if addMemo {
                    //                        TextEditor(
                    //                            text: Binding(
                    //                                get: { memo ?? "" },
                    //                                set: { memo = $0 }
                    //                            )
                    //                        )
                    //                        .border(Color.red, width: 1)
                    //                        .frame(height: 100)
                    //                    }
                    
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
                            dismisCancelButton()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            //                            Button(action: {
                            //                                addMemo = true
                            //                            }) {
                            //                                Image(systemName: "plus")
                            //                            }
                            Button("保存") {
                                addSubscription()
                            }
                            .disabled(subscName.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                    }
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [.cyan.opacity(0.3), .green.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            )
        }
    }
    
    func paymentDateAddView() -> some View {
        VStack {
            Button("保存") {
                paymentDate = tempPaymentDate // 仮の日付をセット
                add = true
                paymentDateView = false
            }
            
            DatePicker("", selection: $tempPaymentDate,
                       displayedComponents: .date)
            .datePickerStyle(.graphical)
        }
    }
        
        func cancelDateAddView() -> some View {
            VStack {
                Button("保存") {
                    cancelDate = tempcancelDate // 仮の日付をセット
                    cancelDateAdd = true
                    cancelDateView = false
                }
                DatePicker("", selection: $tempcancelDate,
                           displayedComponents: .date)
                .datePickerStyle(.graphical)
            }
        }
}

#Preview {
    AddSubscView(subscName: .constant("Previewだよ"), amount: .constant(100), paymentDate: .constant(Date()), cancelDate: .constant(Date()), frequency: .constant(.yearly), startDate: .constant(Date()), addSubscription: {}, dismisCancelButton: {})
}
