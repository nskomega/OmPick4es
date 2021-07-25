//
//  PictureModel.swift
//  OmPick4e
//
//  Created by Mikhail Danilov on 24.07.2021.
//

import Foundation

// MARK: - PictureModel
struct PictureModel: Codable {
    var id: String?
    let width, height: Int?
    let createdAt : Date?
    let urls: Urls?
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String?
    let thumb: String?
}
