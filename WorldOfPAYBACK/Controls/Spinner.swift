//
//  Spinner.swift
//  WorldOfPAYBACK
//
//  Created by Samrez Ikram on 09/02/2023.
//

import SwiftUI
import UIKit

struct Spinner: UIViewRepresentable {
    let isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context _: Context) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: style)
        spinner.hidesWhenStopped = true
        return spinner
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context _: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
