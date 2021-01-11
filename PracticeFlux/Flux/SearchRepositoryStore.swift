//
//  SearchRepositoryStore.swift
//  PracticeFlux
//
//  Created by 河明宗 on 2021/01/11.
//  Copyright © 2021 河明宗. All rights reserved.
//

import Foundation
import GitHub

final class SearchRepositoryStore: Store {
    static let shared = SearchRepositoryStore(dispatcher: .shared)
    private(set) var repositories: [Repository] = []
    
    override func onDispatch(_ action: Action) {
        switch action {
        case let .addRepositories(repositories):
            self.repositories = self.repositories + repositories
        case .clearRepositories:
            self.repositories.removeAll()
        }
        emitChange()
    }
}
