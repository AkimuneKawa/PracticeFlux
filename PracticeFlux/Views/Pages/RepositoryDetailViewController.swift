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

final class RepositoryDetailViewController: UIViewController {
    private let configuration = WKWebViewConfiguration()
    private lazy var webview = WKWebView(frame: .zero, configuration: configuration)
    
    private let detailStore: RepositoryDetailStore
    
    init(detailStore: RepositoryDetailStore = .shared) {
        self.detailStore = detailStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let repository = detailStore.repository else { return }
        webview.load(URLRequest(url: repository.htmlURL))
    }
}
