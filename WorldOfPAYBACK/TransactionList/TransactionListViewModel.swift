//
//  TransactionsListViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Samrez Ikram on 09/02/2023.
//

import Combine
import Foundation

class TransactionListViewModel: ObservableObject {
    @Published private(set) var state = State.idle
    @Published var categories = [Int]()

    private var bag = Set<AnyCancellable>()

    private let input = PassthroughSubject<Event, Never>()

    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(),
                Self.userInput(input: input.eraseToAnyPublisher()),
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }

    deinit {
        bag.removeAll()
    }

    func send(event: Event) {
        input.send(event)
    }
}

// MARK: - Inner Types

extension TransactionListViewModel {
    enum State {
        case idle
        case loading
        case loaded([ListItem])
        case refresh([ListItem])
        case error(Error)
    }

    enum Event {
        case onAppear
        case onTransactionHistoryLoaded([ListItem])
        case onRefreshTransactionHistory
        case onFailedToLoadTransactionHistory(Error)
        case onFailureOfNetwork(Error)
    }

    struct ListItem: Identifiable, Hashable {
        let id: String
        let bankingDate: String
        let partnerDisplayName: String
        let transactionDescription: String
        let amount: Int
        let currency: String
        let category: Int

        init(transactionItem: TransactionHistoryItem) {
            id = transactionItem.alias.reference + transactionItem.transactionDetail.bookingDate + UUID().uuidString
            bankingDate = transactionItem.transactionDetail.bookingDate.formatISODate()
            partnerDisplayName = transactionItem.partnerDisplayName
            transactionDescription = transactionItem.transactionDetail.description ?? ""
            amount = transactionItem.transactionDetail.value.amount
            currency = transactionItem.transactionDetail.value.currency
            category = transactionItem.category
        }

        static func == (lhs: ListItem, rhs: ListItem) -> Bool {
            return lhs.id == rhs.id &&
                lhs.bankingDate == rhs.bankingDate &&
                lhs.partnerDisplayName == rhs.partnerDisplayName &&
                lhs.transactionDescription == rhs.transactionDescription &&
                lhs.amount == rhs.amount &&
                lhs.currency == rhs.currency &&
                lhs.category == rhs.category
        }
    }

    struct TransactionType: Identifiable {
        let id: String
        let category: Int

        init(categoryValue: Int) {
            id = UUID().uuidString
            category = categoryValue
        }
    }
}

// MARK: - State Machine

extension TransactionListViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
            switch event {
            case .onAppear:
                return .loading
            default:
                return state
            }
        case .loading:
            switch event {
            case let .onFailedToLoadTransactionHistory(error):
                return .error(error)
            case let .onTransactionHistoryLoaded(transactions):
                return .loaded(transactions)
            default:
                return state
            }
        case .loaded:
            return state
        case .refresh:
            return .loading
        case .error:
            return state
        }
    }

    static func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            return PaybackService.transactions()
                .retry(2)
                .map { $0.items.sorted(by: {
                    $0.transactionDetail.bookingDate.getISODate().compare($1.transactionDetail.bookingDate.getISODate()) == .orderedDescending
                }).map(ListItem.init)
                }
                .map(Event.onTransactionHistoryLoaded)
                .catch { Just(Event.onFailedToLoadTransactionHistory($0)) }
                .eraseToAnyPublisher()
        }
    }

    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
