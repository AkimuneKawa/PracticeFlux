//
//  RepositorySearchViewController.swift
//  PracticeFlux
//
//  Created by 河明宗 on 2021/01/12.
//  Copyright © 2021 河明宗. All rights reserved.
//

import Foundation
import UIKit
import GitHub
import SnapKit
import Then

final class RepositorySearchViewController: UIViewController {
    private let tableView = UITableView().then {
        $0.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.Const.identifier)
        $0.rowHeight = RepositoryCell.Const.cellHeight
    }
    private let searchController = UISearchController()
    
    private let searchStore: SearchRepositoryStore
    private let actionCreator: ActionCreator
    
    private lazy var reloadSubscription: Subscription = {
        return searchStore.addListner { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }()
    
    private var repositories: [Repository] {
        return searchStore.repositories
    }
    
    init(searchStore: SearchRepositoryStore = .shared, actionCreator: ActionCreator) {
        self.searchStore = searchStore
        self.actionCreator = actionCreator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        searchController.searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        _ = reloadSubscription
        
        navigationItem.searchController = searchController
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension RepositorySearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            actionCreator.clearRepositories()
            actionCreator.searchRepositories(query: text, page: 1)
        }
    }
}

extension RepositorySearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchStore.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.Const.identifier) as! RepositoryCell
        
        cell.inject(repository: searchStore.repositories[indexPath.row])
        
        return cell
    }
}

extension RepositorySearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = searchStore.repositories[indexPath.row]
        actionCreator.setSearchRepository(repository)
    }
}
