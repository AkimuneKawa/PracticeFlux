//
//  ActionCreator.swift
//  PracticeFlux
//
//  Created by 河明宗 on 2021/01/08.
//  Copyright © 2021 河明宗. All rights reserved.
//

import Foundation
import GitHub

enum Action {
    case addRepositories([Repository])
    case clearRepositories
    case setSelectedRepository(Repository)
    case setFavoriteRepositories([Repository])
}

final class ActionCreator {
    private let dispacher: Dispatcher
    private let apiSession: GitHubApiRequestable
    private let localCache: LocalCacheable
    
    init(
        dispacher: Dispatcher = .shared,
        apiSession: GitHubApiRequestable = GitHubApiSession.shared,
        localCache: LocalCacheable = LocalCache.shared
    ) {
        self.dispacher = dispacher
        self.apiSession = apiSession
        self.localCache = localCache
    }
}

// MARK: Search

extension ActionCreator {
    func searchRepositories(query: String, page: Int) {
        apiSession.searchRepositories(query: query, page: page) { [dispacher] result in
            switch result {
            case let .success((repositories, _)):
                dispacher.dispatch(.addRepositories(repositories))
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func clearRepositories() {
        dispacher.dispatch(.clearRepositories)
    }
}

// MARK: Favorite

extension ActionCreator {
    func addFavoriteRepository(_ repository: Repository) {
        let repositories = localCache[.favorites] + [repository]
        localCache[.favorites] = repositories
        dispacher.dispatch(.setFavoriteRepositories(repositories))
    }
    
    func removeFavoriteRepository(_ repository: Repository) {
        let repositories = localCache[.favorites].filter { $0.id != repository.id }
        localCache[.favorites] = repositories
        dispacher.dispatch(.setFavoriteRepositories(repositories))
    }
    
    func loadFavoriteRepositories() {
        dispacher.dispatch(.setFavoriteRepositories(localCache[.favorites]))
    }
}

// MARK: Others

extension ActionCreator {
    func setSearchRepository(_ repository: Repository) {
        dispacher.dispatch(.setSelectedRepository(repository))
    }
}
