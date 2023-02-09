//
//  PaybackService.swift
//  WorldOfPAYBACK
//
//  Created by Samrez Ikram on 09/02/2023.
//

import Foundation
import Combine

enum PaybackService {
  static let base = URL(string: "https://api-test.payback.com/")!
  private static let apiKey = ""
  static let agent = PaybackAgent()
}

extension PaybackService {
  
  // Load transaction once Backend is ready
  static func transactionsHttp() -> AnyPublisher<TransactionHistory, Error> {
    let request = URLRequest(url: base.appendingPathComponent("transactions"))
    return agent.run(request)
  }
  
  static func transactions() -> TransactionHistory? {
    if let url = Bundle.main.url(forResource: "PBTransactions", withExtension: "json") {
      do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode(TransactionHistory.self, from: data)
        return jsonData
      } catch {
        print("error:\(error)")
      }
    }
    return nil
  }
  
}
