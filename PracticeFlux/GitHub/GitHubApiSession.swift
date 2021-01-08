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
