//
//  PicturesService.swift
//  OmPick4e
//
//  Created by Mikhail Danilov on 24.07.2021.
//

import Foundation
import Alamofire

final class PicturesService {
    
    var favorites = [PictureModel]()
    
    func getPicturs(completion: @escaping ([PictureModel]?) -> Void) {
        let _url = "https://api.unsplash.com/photos/?client_id=VpeE4GGkWafAKhsc6q5-8yKl23jE8TsPQ6oDPNIoFzU"
        guard let url = URL(string: _url) else {
            completion(nil)
            return
        }
        
        AF.request(url).responseJSON { response in
            
            switch response.result {
            case .success:
                guard let data = response.data else {
                    completion(nil)
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let list = try decoder.decode([PictureModel].self, from: data)
                    completion(list)
                } catch let error {
                    print(error)
                    completion(nil)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
