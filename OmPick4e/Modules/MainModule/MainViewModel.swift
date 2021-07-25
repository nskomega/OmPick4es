//
//  MainViewModel.swift
//  OmPick4e
//
//  Created by Mikhail Danilov on 23.07.2021.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import SDWebImage

protocol MainTableViewModelProtocol: AnyObject {
    var currentPictureRelay: BehaviorRelay<PictureModel> { get }
    var timerRelay: BehaviorRelay<String> { get }
    func viewDidLoad()
    func tapLike() -> Bool
    func containsPicture(id: String) -> Bool
    func tapShowFavorites()
}

class MainViewModel: MainTableViewModelProtocol {

    // MARK: Properties
    var favorites: FavoritesView?
    
    var notificationToken: NotificationToken?
    
    let realm = RealmService.shared.realm
    
    var picResults: Results<PictureRealm>!
    
    private let router: MainRouter
    var picturesService = PicturesService()
    let currentPictureRelay = BehaviorRelay<PictureModel>(value: PictureModel(id: nil, width: nil, height: nil, createdAt: nil, urls: nil))
    let timerRelay = BehaviorRelay<String>(value: "")
    var timerValue = 0
    private var list = [PictureModel]()
    
    private var timer = Timer()
    
    init(router: MainRouter) {
        self.router = router
    }
    
    // MARK: Methods
    func viewDidLoad() {
        loadPicturs()
    }
    
    private func loadPicturs() {
        picturesService.getPicturs { [weak self] list in
            if let list = list {
                self?.list = list
                self?.startTimer()
            } else {
                print("Чтото пошло не так")
            }
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(eventWith(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc func eventWith(timer: Timer!) {
        timerValue -= 1
        if timerValue < 1 {
            timerValue = Int.random(in: 0..<120)
            let randomInt = Int.random(in: 0..<list.count-1)
            let model = list[randomInt]
            self.currentPictureRelay.accept(model)
        }
        timerRelay.accept(String(timerValue))
    }
    
    func containsPicture(id: String) -> Bool {
        let items = picturesService.favorites.filter { $0.id == id }
        if items.isEmpty {
          return false
        } else {
            return true
        }
    }
    
    func tapLike() -> Bool {
        guard let id = currentPictureRelay.value.id else { return false }
        let items = picturesService.favorites.filter { $0.id == id }
        picResults = realm.objects(PictureRealm.self)
        
        notificationToken = realm.observe { (notification, realm) in
            self.favorites?.tableView.reloadData()
        }
        
        
        
        let imgPic = UIImageView()
        guard let url = currentPictureRelay.value.urls?.small else { return false }
        imgPic.sd_setImage(with: URL(string: url))
        let imgFinal = imgPic.image
        guard let img = imgFinal else { return true }
        let imgString = convertImageToBase64String(img: img)
        let newPic = PictureRealm(id: currentPictureRelay.value.id!, width: currentPictureRelay.value.width!, height: currentPictureRelay.value.height!, saveImg: imgString)
        if items.isEmpty {
            RealmService.shared.create(newPic)

            notificationToken?.invalidate()
            return true
        } else {
            picturesService.favorites = picturesService.favorites.filter { $0.id != id }
            RealmService.shared.delete(newPic)
            notificationToken?.invalidate()
            return false
        }
    }
    
    func tapShowFavorites() {
        router.showFavorites(picturesService: picturesService)
    }
}
