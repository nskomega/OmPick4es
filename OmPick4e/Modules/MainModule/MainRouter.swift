//
//  MainRouter.swift
//  OmPick4e
//
//  Created by Mikhail Danilov on 23.07.2021.
//

import Foundation
import UIKit
import RxRelay

protocol MainRouterProtocol: AnyObject {
    func showFavorites(picturesService: PicturesService)
}

final class MainRouter: MainRouterProtocol {
    func showTableVC() {
    }
    
    
    // MARK: Properties
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    // MARK: Internal helpers
    func showFavorites(picturesService: PicturesService) {
        let module = ModuleBuilder.favoritesVC(picturesService: picturesService)
        viewController?.present(module, animated: true, completion: nil)
    }
}
