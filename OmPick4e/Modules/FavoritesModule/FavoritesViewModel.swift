//
//  FavoritesViewModel.swift
//  OmPick4e
//
//  Created by Mikhail Danilov on 24.07.2021.
//

import Foundation

protocol FavoritesViewModelProtocol {
}
    
final class FavoritesViewModel: FavoritesViewModelProtocol {
    
    private let router: FavoritesRouterProtocol
//    private let picturesService: PicturesService
    
//    var favorites: [PictureModel] {
//        return picturesService.favorites
//    }
    
    init(router: FavoritesRouterProtocol) { //, picturesService: PicturesService) {
        self.router = router
//        self.picturesService = picturesService
    }
}
