//
//  Base64.swift
//  OmPick4e
//
//  Created by Mikhail Danilov on 25.07.2021.
//

import Foundation
import UIKit

func convertImageToBase64String (img: UIImage) -> String {
    return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
}

//
// Convert a base64 representation to a UIImage
//
func convertBase64StringToImage (imageBase64String: String) -> UIImage {
    let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
    guard let image = UIImage(data: imageData!) else { return UIImage() }
    return image
}

