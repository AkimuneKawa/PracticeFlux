//
//  FavoriteRepositoryViewController.swift
//  PracticeFlux
//
//  Created by 河明宗 on 2021/02/22.
//  Copyright © 2021 河明宗. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit

final class FavoriteRepositoryViewController: UIViewController {
    private let tableView = UITableView().then {
        $0.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.Const.identifier)
        $0.rowHeight = RepositoryCell.Const.cellHeight
    }
    
    private let favoriteStore: FavoriteRepositoryStore
    private let actionCreator: ActionCreator
    
    init(favoriteStore: FavoriteRepositoryStore = .shared, actionCreator: ActionCreator) {
        self.favoriteStore = favoriteStore
        self.actionCreator = actionCreator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var reloadSubscription: Subscription = { [weak self] in
        return favoriteStore.addListner {
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = reloadSubscription
        actionCreator.loadFavoriteRepositories()
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.dataSource = self
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension FavoriteRepositoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteStore.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.Const.identifier) as! RepositoryCell
        
        cell.inject(repository: favoriteStore.repositories[indexPath.row])
        
        return cell
    }
}
