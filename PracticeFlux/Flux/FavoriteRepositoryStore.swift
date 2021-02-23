//
//  FavoriteRepositoryStore.swift
//  PracticeFlux
//
//  Created by 河明宗 on 2021/02/22.
//  Copyright © 2021 河明宗. All rights reserved.
//

import Foundation
import GitHub

final class FavoriteRepositoryStore: Store {
    static let shared = FavoriteRepositoryStore()
    
    private(set) var repositories: [Repository] = []
    
    override func onDispatch(_ action: Action) {
        switch action {
        case .setFavoriteRepositories(let repos):
            self.repositories = repos
        default:
            return
        }
        emitChange()
    }
}
