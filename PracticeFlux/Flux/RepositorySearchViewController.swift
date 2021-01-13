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

final class RepositorySearchViewController: UIViewController, UISearchBarDelegate {
    private let tableView = UITableView()
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
        _ = reloadSubscription
    }
    
    private func setupConstraints() {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            actionCreator.clearRepositories()
            actionCreator.searchRepositories(query: text, page: 1)
        }
    }
}
