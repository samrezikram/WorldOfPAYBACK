//
//  TransactionDetailView.swift
//  WorldOfPAYBACK
//
//  Created by Samrez Ikram on 12/02/2023.
//

import Combine
import SwiftUI

struct TransactionDetailView: View {
    @ObservedObject var viewModel: TransactionDetailViewModel

    var body: some View {
        content
            .onAppear { self.viewModel.send(event: .onAppear) }
    }

    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return spinner.eraseToAnyView()
        case let .error(error):
            return Text(error.localizedDescription).eraseToAnyView()
        case let .loaded(transactionItem):
            return self.transaction(transactionItem).eraseToAnyView()
        }
    }

    private func transaction(_ transactionItem: TransactionListViewModel.ListItem) -> some View {
        VStack {
            fillWidth

            Text(transactionItem.partnerDisplayName)
                .font(.largeTitle)
                .multilineTextAlignment(.center)

            Divider()

            HStack {
                Text(transactionItem.transactionDescription)
            }
            .font(.subheadline)
        }
    }

    private var fillWidth: some View {
        HStack {
            Spacer()
        }
    }

    private var spinner: Spinner { Spinner(isAnimating: true, style: .large) }
}
