//
//  ModuleBuilder.swift
//  OmPick4e
//
//  Created by Mikhail Danilov on 23.07.2021.
//

import Foundation
import UIKit
import RxRelay

class ModuleBuilder {
    
    static func mainVC() -> UIViewController {
    
        let viewController = MainViewController()
        let view = MainView()
        let router = MainRouter(viewController: viewController)
        let viewModel = MainViewModel(router: router)
        view.setup(viewModel: viewModel)
        viewController.view = view
        viewController.view.backgroundColor = .white

        return viewController
    }
    
    static func favoritesVC(picturesService: PicturesService) -> UIViewController {
    
        let viewController = FavoritesViewController()
        let view = FavoritesView()
        let router = FavoritesRouter(viewController: viewController)
        let viewModel = FavoritesViewModel(router: router) //, picturesService: picturesService)
        view.setup(viewModel: viewModel)
        viewController.view = view
        viewController.view.backgroundColor = .white

        return viewController
    }
}
