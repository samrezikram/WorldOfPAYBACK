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
  
  static func transactions() -> AnyPublisher<TransactionHistory, Error> {
    Bundle.main.readFile(file: "PBTransactions", ext: "json")
      .decode(type: TransactionHistory.self, decoder: JSONDecoder())
      .mapError { error in
        return error
      }.eraseToAnyPublisher()
  }
}

extension Bundle{
  func readFile(file: String, ext: String) -> AnyPublisher<Data, Error> {
    self.url(forResource: file, withExtension: ext)
      .publisher
      .tryMap { string in
        guard let data = try? Data(contentsOf: string) else {
          fatalError("Failed to load \(file) from bundle.")
        }
        return data
      }
      .mapError { error in
        return error
      }.eraseToAnyPublisher()
  }
}
