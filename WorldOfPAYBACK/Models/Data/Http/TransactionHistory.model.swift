//
//  TransactionHistory.model.swift
//  WorldOfPAYBACK
//
//  Created by Samrez Ikram on 09/02/2023.
//

import Foundation

// MARK: - TransactionHistory

struct TransactionHistory: Codable {
    let items: [TransactionHistoryItem]
}

// MARK: - Item

struct TransactionHistoryItem: Codable {
    let partnerDisplayName: String
    let alias: TransactionAlias
    let category: Int
    let transactionDetail: TransactionDetail
}

// MARK: - Alias

struct TransactionAlias: Codable {
    let reference: String
}

// MARK: - TransactionDetail

struct TransactionDetail: Codable {
    let description: String?
    let bookingDate: String
    let value: TransactionValue
}

// MARK: - Value

struct TransactionValue: Codable {
    let amount: Int
    let currency: String
}
