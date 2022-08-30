//
//  SearchRouter.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 30.08.2022.
//

import UIKit

protocol SearchRoutingLogic {
    func showFailure(message: String)
}

final class SearchRouter: SearchRoutingLogic {
    weak var source: UIViewController?

    func showFailure(message: String) {
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        source?.present(ac, animated: true)
    }
}
