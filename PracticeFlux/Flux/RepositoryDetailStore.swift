//
//  RepositoryDetailStore.swift
//  PracticeFlux
//
//  Created by 河明宗 on 2021/01/16.
//  Copyright © 2021 河明宗. All rights reserved.
//

import Foundation
import GitHub

final class RepositoryDetailStore: Store {
    static let shared = RepositoryDetailStore()
    private(set) var repository: Repository?
    
    override func onDispatch(_ action: Action) {
        switch action {
        case let .setSelectedRepository(repository):
            self.repository = repository
        default:
            return
        }
        emitChange()
    }
}
