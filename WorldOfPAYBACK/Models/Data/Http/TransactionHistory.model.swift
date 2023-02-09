//
//  TransactionHistory.model.swift
//  WorldOfPAYBACK
//
//  Created by Samrez Ikram on 09/02/2023.
//

import Foundation

// MARK: - TransactionHistory
struct TransactionHistory: Codable {
  let transactionItems: [TransactionHistoryItem?]
}

// MARK: - Item
struct TransactionHistoryItem: Codable {
  let partnerDisplayName: String
  let alias: TransactionAlias?
  let category: Int
  let transactionDetail: TransactionDetail?
}

// MARK: - Alias
struct TransactionAlias: Codable {
  let reference: String
}

// MARK: - TransactionDetail
struct TransactionDetail: Codable {
  let description: TransactionDescription?
  let bookingDate: Date
  let value: TransactionValue
}

struct TransactionDescription: Codable {
  let punkteSammeln: String
}

// MARK: - Value
struct TransactionValue: Codable {
    let amount: Int
    let currency: String
}
