//
//  ContentView.swift
//  WorldOfPAYBACK
//
//  Created by Samrez Ikram on 09/02/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TransactionListView(viewModel: TransactionListViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
