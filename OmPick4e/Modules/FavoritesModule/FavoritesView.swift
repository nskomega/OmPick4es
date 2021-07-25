//
//  FavoritesView.swift
//  OmPick4e
//
//  Created by Mikhail Danilov on 24.07.2021.
//

import Foundation

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SDWebImage
import RealmSwift

class FavoritesView: UIView {
    
    let realm = RealmService.shared.realm
    var items: Results<PictureRealm>!
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.text = "title"
        return label
    }()
    
    public let tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    var viewModel: FavoritesViewModelProtocol?
    
    // MARK: Methods
    func setup(viewModel: FavoritesViewModelProtocol) {
        items = realm.objects(PictureRealm.self)
        self.viewModel = viewModel
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        loadView()
        
    }
    
    func loadView() {
        self.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

extension FavoritesView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = items?[indexPath.row].id
        cell.imageView?.image = convertBase64StringToImage(imageBase64String: (items?[indexPath.row].saveImg)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            try! realm.write {
                realm.delete(items[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
