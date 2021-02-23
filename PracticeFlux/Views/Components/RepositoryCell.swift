//
//  RepositoryCell.swift
//  PracticeFlux
//
//  Created by 河明宗 on 2021/01/16.
//  Copyright © 2021 河明宗. All rights reserved.
//

import Foundation
import UIKit
import GitHub
import SnapKit

final class RepositoryCell: UITableViewCell {
    struct Const {
        static let identifier: String = "RepositoryCell"
        static let cellHeight: CGFloat = 40
    }
    
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    private func setupViews() {
        addSubview(label)
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().offset(8)
        }
    }
    
    
    func inject(repository: Repository) {
        label.text = repository.name
    }
}
