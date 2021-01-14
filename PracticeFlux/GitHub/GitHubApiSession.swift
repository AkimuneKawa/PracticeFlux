//
//  GitHubApiSession.swift
//  PracticeFlux
//
//  Created by 河明宗 on 2021/01/08.
//  Copyright © 2021 河明宗. All rights reserved.
//

import Foundation
import GitHub

protocol GitHubApiRequestable: AnyObject {
    func searchRepositories(query: String, page: Int, completion: @escaping (Result<([GitHub.Repository], GitHub.Pagination)>) -> ())
}

final class GitHubApiSession: GitHubApiRequestable {
    static let shared = GitHubApiSession()
    
    private let session = GitHub.Session()
    
    func searchRepositories(query: String, page: Int, completion: @escaping (Result<([Repository], Pagination)>) -> ()) {
        let request = SearchRepositoriesRequest(query: query, sort: .stars, order: .desc, page: page, perPage: nil)
        
        session.send(request, completion: { result in
            switch result {
            case let .success((response, pagination)):
                completion(.success((response.items, pagination)))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
}
