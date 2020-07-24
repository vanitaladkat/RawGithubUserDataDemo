//
//  TextTableViewCell.swift
//  RawGithubUserDataDemo
//
//  Created by Vanita Ladkat on 21/07/20.
//  Copyright © 2020 Vanita Ladkat. All rights reserved.
//

import UIKit
import SnapKit

class TextTableViewCell: UITableViewCell {

    lazy var contentLabel = UILabel()
    lazy var timeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    func setupUI() {
        self.addSubview(contentLabel)
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.trailing.equalTo(-10)
            make.height.equalTo(30)
        }
        contentLabel.numberOfLines = 2
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          contentLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8)
        ])
        contentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.bottom.equalTo(-10)
        }
    }

}
