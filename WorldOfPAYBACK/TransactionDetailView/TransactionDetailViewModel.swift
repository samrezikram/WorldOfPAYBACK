//
//  TransactionDetailViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Samrez Ikram on 12/02/2023.
//

import Combine
import Foundation

final class TransactionDetailViewModel: ObservableObject {
    @Published private(set) var state: State

    private var bag = Set<AnyCancellable>()

    private let input = PassthroughSubject<Event, Never>()

    init(transactionItem: TransactionListViewModel.ListItem) {
        state = .idle(transactionItem)

        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.userInput(input: input.eraseToAnyPublisher()),
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }

    func send(event: Event) {
        input.send(event)
    }
}

// MARK: - Inner Types

extension TransactionDetailViewModel {
    enum State {
        case idle(TransactionListViewModel.ListItem)
        case loading(TransactionListViewModel.ListItem)
        case loaded(TransactionListViewModel.ListItem)
        case error(Error)
    }

    enum Event {
        case onAppear
        case onLoaded(TransactionListViewModel.ListItem)
        case onFailedToLoad(Error)
    }
}

// MARK: - State Machine

extension TransactionDetailViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case let .idle(transactionItem):
            switch event {
            case .onAppear:
                return .loaded(transactionItem)
            default:
                return state
            }
        case .loading:
            switch event {
            case let .onFailedToLoad(error):
                return .error(error)
            case let .onLoaded(transactionItem):
                return .loaded(transactionItem)
            default:
                return state
            }
        case .loaded:
            return state
        case .error:
            return state
        }
    }

    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback(run: { _ in
            input
        })
    }
}
