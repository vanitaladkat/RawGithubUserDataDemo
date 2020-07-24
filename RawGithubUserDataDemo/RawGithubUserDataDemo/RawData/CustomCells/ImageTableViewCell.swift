//
//  ImageTableViewCell.swift
//  RawGithubUserDataDemo
//
//  Created by Vanita Ladkat on 21/07/20.
//  Copyright © 2020 Vanita Ladkat. All rights reserved.
//

import UIKit
import SnapKit

class ImageTableViewCell: UITableViewCell {

    lazy var timeLabel = UILabel()
    lazy var contentImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupUI() {
        self.addSubview(timeLabel)
        self.addSubview(contentImageView)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.trailing.equalTo(-10)
            make.height.equalTo(30)
        }
        contentImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          contentImageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 15)
        ])
        let imageWidth = UIScreen.main.bounds.width - 20
        contentImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.bottom.equalTo(-10)
            make.height.equalTo(imageWidth)
        }
        contentImageView.contentMode = .scaleAspectFit
        contentImageView.clipsToBounds = true
    }
}
