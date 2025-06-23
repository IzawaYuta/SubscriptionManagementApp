//
//  Model.swift
//  SubscriptionManagementApp
//
//  Created by Engineer MacBook Air on 2025/06/20.
//

import Foundation
import RealmSwift

class SubscriptionModel: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString // 一意の識別子
    @Persisted var subscName: String // サブスクリプション名前
    @Persisted var amount: Int? // 金額
    @Persisted var paymentDate: Date? // 支払日
    @Persisted var cancelDate: Date? // 解約日
    @Persisted var frequency: String // 支払い頻度（年額、月額、買いきり）
    @Persisted var memo: String? // メモ
    @Persisted var startDate: Date? // 開始日
}
