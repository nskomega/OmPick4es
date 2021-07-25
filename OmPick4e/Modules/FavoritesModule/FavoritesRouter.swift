//
//  FavoritesRouter.swift
//  OmPick4e
//
//  Created by Mikhail Danilov on 24.07.2021.
//

import UIKit

protocol FavoritesRouterProtocol {
    
}
    
final class FavoritesRouter: FavoritesRouterProtocol {
    // MARK: Properties
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    // MARK: Internal helpers
}
