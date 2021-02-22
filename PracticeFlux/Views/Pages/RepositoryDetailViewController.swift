//
//  RepositoryDetailViewController.swift
//  PracticeFlux
//
//  Created by 河明宗 on 2021/01/16.
//  Copyright © 2021 河明宗. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import SnapKit
import Then

final class RepositoryDetailViewController: UIViewController {
    private let configuration = WKWebViewConfiguration()
    private lazy var webview = WKWebView(frame: .zero, configuration: configuration)
    private lazy var favoriteButton: UIBarButtonItem = {
        return .init(
            title: nil,
            style: .plain,
            target: self,
            action: #selector(self.tappedFavoriteButton(_:)))
    }()
    
    private let detailStore: RepositoryDetailStore
    private let favoriteStore: FavoriteRepositoryStore
    private let actionCreator: ActionCreator
    
    private lazy var repositoryStoreSubscription: Subscription = {
        return favoriteStore.addListner { [weak self] in
            DispatchQueue.main.async { self?.updateFavoriteButton() }
        }
    }()
    
    init(
        detailStore: RepositoryDetailStore = .shared,
        favoriteStore: FavoriteRepositoryStore = .shared,
        actionCreator: ActionCreator
    ) {
        self.detailStore = detailStore
        self.favoriteStore = favoriteStore
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
        navigationItem.rightBarButtonItem = favoriteButton
        updateFavoriteButton()
        
        _ = repositoryStoreSubscription
        
        guard let repository = detailStore.repository else { return }
        webview.load(URLRequest(url: repository.htmlURL))
        view.addSubview(webview)
    }
    
    private func setupConstraints() {
        webview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateFavoriteButton() {
        let isFavorite = favoriteStore.repositories.contains(where: { $0.id == detailStore.repository?.id })
        favoriteButton.title = isFavorite ? "★ Unstar" : "⭐︎ Star"
    }
    
    @objc private func tappedFavoriteButton(_ button: UIBarButtonItem) {
        guard let repository = detailStore.repository else { return }
        
        if favoriteStore.repositories.contains(where: { $0.id == repository.id }) {
            actionCreator.removeFavoriteRepository(repository)
        } else {
            actionCreator.addFavoriteRepository(repository)
        }
    }
}
