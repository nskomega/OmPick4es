//
//  MainView.swift
//  OmPick4e
//
//  Created by Mikhail Danilov on 23.07.2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SDWebImage
import RealmSwift
import RxGesture

class MainView: UIView {
    
    private var viewModel: MainTableViewModelProtocol?
    private let disposeBag = DisposeBag()
    
    // MARK: - Subviews
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = label.font.withSize(15)
        label.textColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var heigthPic: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = label.font.withSize(15)
        label.textColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var widthPic: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = label.font.withSize(15)
        label.textColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createdAtLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = label.font.withSize(15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .orange
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "war")
        image.layer.borderWidth = 2.0
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = 18.0
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .orange
        label.font = label.font.withSize(25)
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dislike"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let favoritesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "star"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: Methods
    func setup(viewModel: MainTableViewModelProtocol) {
        self.viewModel = viewModel
        
        viewModel.currentPictureRelay
            .asObservable()
            .subscribe(onNext: { [weak self] model in
                guard let viewModel = self?.viewModel else { return }
                guard let url = model.urls?.small else { return }
                self?.imageView.sd_setImage(with: URL(string: url))
                
                let _width: CGFloat = (self?.imageView.bounds.width)!
                let heigth = model.height!
                let width = model.width!
                let heightNew = Int(Int(_width) * heigth / width)
                
                self?.imageView.heightAnchor.constraint(equalToConstant: CGFloat(heightNew)).isActive = true
                
                self?.idLabel.text = "ID: \(model.id!)"
                self?.heigthPic.text = "Height: \(model.height ?? 0)"
                self?.widthPic.text = "Widht: \(model.width ?? 0)"
                self?.createdAtLabel.text = model.createdAt?.dayMonthYearFormat() ?? "CreatedAt: Unknown"
                
                if viewModel.containsPicture(id: model.id ?? "") {
                    self?.likeButton.setImage(UIImage(named: "dislike"), for: .normal)
                } else {
                    self?.likeButton.setImage(UIImage(named: "like"), for: .normal)
                }
            }).disposed(by: disposeBag)
        
        viewModel.timerRelay
            .asObservable()
            .subscribe(onNext: { [weak self] time in
                self?.timerLabel.text = time
            }).disposed(by: disposeBag)
        
        imageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] event in
                guard let self = self , let viewModel = self.viewModel else { return }
                let imgColor = viewModel.tapLike() ? "dislike" : "like"
                
                //Animate Pictures
                UIView.animate(withDuration: 1.0, delay: 0.0, options: .autoreverse, animations: {
                    self.imageView.alpha = 0.3
                }, completion: { finished in
                    self.imageView.alpha = 1.0
                })
                
                
                self.likeButton.setImage(UIImage(named: imgColor), for: .normal)
            }).disposed(by: disposeBag)
        
        likeButton.rx
            .tap
            .subscribe { [weak self] event in
            guard let self = self , let viewModel = self.viewModel else { return }
            let imgColor = viewModel.tapLike() ? "dislike" : "like"
            
            //Animate Pictures
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .autoreverse, animations: {
                self.imageView.alpha = 0.3
            }, completion: { finished in
                self.imageView.alpha = 1.0
            })
            
            self.likeButton.setImage(UIImage(named: imgColor), for: .normal)
        }.disposed(by: disposeBag)
        
        
        favoritesButton.rx.tap.subscribe { [weak self] event in
            self?.viewModel?.tapShowFavorites()
        }.disposed(by: disposeBag)
        
        loadView()
        
        viewModel.viewDidLoad()
    }
    
    func loadView() {
        self.addSubview(timerLabel)
        self.addSubview(imageView)
        self.addSubview(idLabel)
        self.addSubview(heigthPic)
        self.addSubview(widthPic)
        self.addSubview(createdAtLabel)
        self.addSubview(likeButton)
        self.addSubview(favoritesButton)
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(45)
            $0.leading.equalToSuperview().offset(26)
            $0.trailing.equalToSuperview().offset(-26)
        }
        
        favoritesButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.top).offset(16)
            $0.leading.equalTo(imageView.snp.leading).offset(16)
            $0.height.equalTo(40)
            $0.width.equalTo(40)
        }
        
        likeButton.snp.makeConstraints {
            $0.centerY.equalTo(favoritesButton.snp.centerY)
            $0.trailing.equalTo(imageView).offset(-16)
            $0.height.equalTo(40)
            $0.width.equalTo(40)
        }
        
        createdAtLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-26)
            $0.centerX.equalToSuperview()
        }
        
        timerLabel.snp.makeConstraints {
            $0.centerY.equalTo(createdAtLabel.snp.centerY)
            $0.leading.equalTo(imageView).offset(16)
            $0.height.equalTo(25)
        }
        
        idLabel.snp.makeConstraints {
            $0.bottom.equalTo(heigthPic.snp.top).offset(-6)
            $0.centerX.equalToSuperview()
        }
        
        heigthPic.snp.makeConstraints {
            $0.bottom.equalTo(widthPic.snp.top).offset(-6)
            $0.centerX.equalToSuperview()
        }
        
        widthPic.snp.makeConstraints {
            $0.bottom.equalTo(createdAtLabel.snp.top).offset(-6)
            $0.centerX.equalToSuperview()
        }
    }
}

extension Date {
    func dayMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/mm/yyyy"
        return dateFormatter.string(from: self)
    }
}
