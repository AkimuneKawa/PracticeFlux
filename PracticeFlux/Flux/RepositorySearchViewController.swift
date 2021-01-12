//
//  RepositorySearchViewController.swift
//  PracticeFlux
//
//  Created by 河明宗 on 2021/01/12.
//  Copyright © 2021 河明宗. All rights reserved.
//

import Foundation
import UIKit

final class RepositorySearchViewController: UIViewController, UISearchBarDelegate {
    private let searchStore: SearchRepositoryStore
    private let actionCreator: ActionCreator
    
    init(searchStore: SearchRepositoryStore = .shared, actionCreator: ActionCreator) {
        self.searchStore = searchStore
        self.actionCreator = actionCreator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
