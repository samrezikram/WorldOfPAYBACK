//
//  TransactionListView.swift
//  WorldOfPAYBACK
//
//  Created by Samrez Ikram on 09/02/2023.
//

import Combine
import SwiftUI

struct TransactionListView: View {
    @ObservedObject var viewModel: TransactionListViewModel
    @State var showSheet = false
    @State var categories: [Int] = [1, 2, 3]

    var body: some View {
        NavigationView {
            content
                .navigationBarTitle("Transaction History")
        }
        .onAppear { self.viewModel.send(event: .onAppear) }
    }

    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return Network.isConnected ? Spinner(isAnimating: true, style: .large).eraseToAnyView() : Text("We're \(Network.isConnected ? "connected" : "not connected") to the Internet.")
                .bold().eraseToAnyView()
        case let .error(error):
            return Text(error.localizedDescription).eraseToAnyView()
        case let .loaded(transactions):
            return list(of: transactions, categories: [TransactionListViewModel.TransactionType(categoryValue: 2), TransactionListViewModel.TransactionType(categoryValue: 4), TransactionListViewModel.TransactionType(categoryValue: 9)]).eraseToAnyView()
        case let .refresh(transactions):
            return list(of: transactions, categories: [TransactionListViewModel.TransactionType(categoryValue: 2), TransactionListViewModel.TransactionType(categoryValue: 4), TransactionListViewModel.TransactionType(categoryValue: 9)]).eraseToAnyView()
        }
    }

    private func list(of transactions: [TransactionListViewModel.ListItem], categories: [TransactionListViewModel.TransactionType]) -> some View {
        return
            ZStack(alignment: Alignment(horizontal: .center, vertical: VerticalAlignment.bottom), content: {
                List(transactions) { transaction in
                    NavigationLink(
                        destination: TransactionDetailView(viewModel: TransactionDetailViewModel(transactionItem: transaction)),
                        label: {
                            TransactionViewCell(transaction: transaction)
                                .padding()
                                .listRowSeparator(.visible, edges: .all)
                                .refreshable {
                                    self.viewModel.send(event: .onRefreshTransactionHistory)
                                }
                        }
                    )
                }
                BottomSheetView(isOpen: $showSheet, maxHeight: 90 * CGFloat(categories.count)) {
                    BottomSheet(categories: categories)
                }.ignoresSafeArea(.all, edges: .bottom)
            })
    }
}

struct TransactionViewCell: View {
    let transaction: TransactionListViewModel.ListItem
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack {
                    Text(transaction.bankingDate).bold().font(.system(size: 16))
                }
                Spacer()
                HStack(alignment: .lastTextBaseline) {
                    Text(transaction.partnerDisplayName).bold().font(.system(size: 11))
                    Spacer()
                    HStack(spacing: 2) {
                        Text(String(transaction.amount)).font(.system(size: 11, weight: .bold, design: .monospaced))
                        Text(transaction.currency).font(.system(size: 9, weight: .bold, design: .monospaced))
                    }
                }
                VStack(alignment: .center) {
                    HStack {
                        Text(transaction.transactionDescription).font(.system(size: 11)).frame(alignment: .leading)
                        Text(String(transaction.category)).font(.system(size: 9, weight: .bold, design: .monospaced))
                    }.foregroundColor(.gray)
                }
            }
        }
    }
}

struct BottomSheet: View {
    let categories: [TransactionListViewModel.TransactionType]

    //  @Binding var categories: [Int]
    var body: some View {
        HStack {
            Text("Filter by Category ")
        }
        List {
            ForEach(categories) { category in
                CategoryViewCell(category: category)
            }.listRowSeparator(.visible, edges: .all)
        }
    }
}

struct CategoryViewCell: View {
    let category: TransactionListViewModel.TransactionType
    var body: some View {
        HStack(alignment: .center) {
            Text(String(category.category)).bold().font(.system(size: 16))
        }
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context _: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }

    func updateUIView(_: UIVisualEffectView, context _: Context) {}
}
