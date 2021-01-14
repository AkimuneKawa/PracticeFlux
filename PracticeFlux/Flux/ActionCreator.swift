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
}

final class ActionCreator {
    private let dispacher: Dispatcher
    private let apiSession: GitHubApiRequestable
    
    init(
        dispacher: Dispatcher = .shared,
        apiSession: GitHubApiRequestable = GitHubApiSession.shared
    ) {
        self.dispacher = dispacher
        self.apiSession = apiSession
    }
    
    func searchRepositories(query: String, page: Int) {
        apiSession.searchRepositories(query: query, page: page) { [dispacher] result in
            switch result {
            case let .success(repositories, _):
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
