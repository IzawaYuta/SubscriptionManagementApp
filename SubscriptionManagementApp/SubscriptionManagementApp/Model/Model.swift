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
    @Persisted var subscName: String
    @Persisted var amount: Int
}
