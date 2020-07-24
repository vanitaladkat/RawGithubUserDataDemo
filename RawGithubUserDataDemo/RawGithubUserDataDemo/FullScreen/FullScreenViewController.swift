//
//  FullScreenViewController.swift
//  RawGithubUserDataDemo
//
//  Created by Vanita Ladkat on 21/07/20.
//  Copyright © 2020 Vanita Ladkat. All rights reserved.
//

import UIKit
import SnapKit

class FullScreenViewController: UIViewController {
 
    lazy var scrollView = UIScrollView()
    lazy var imageView = UIImageView()
    lazy var contentLabel = UILabel()
    var rawUserDataModel: RawUserDataModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }


    func setupUI() {
        view.backgroundColor = .white
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        if let contentType = rawUserDataModel?.contentType(), contentType == .image {
            scrollView.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.top.equalTo(10)
                make.leading.equalTo(10)
                make.trailing.equalTo(-10)
                make.bottom.equalTo(-10)
//                make.center.centerY.equalToSuperview()
            }
//            imageView.snp.makeConstraints { (make) in
//                make.top.bottom.equalTo(self.scrollView)
//                make.left.right.equalTo(self.view)
//                make.width.equalTo(self.scrollView)
//                make.height.equalTo(self.scrollView)
//            }
            let imgUrl = rawUserDataModel?.data ?? ""
            imageView.setImage(from: imgUrl, placeHolder: nil) { [weak self] (img) in
                self?.imageView.contentMode = .scaleAspectFit
            }
        } else {
            scrollView.addSubview(contentLabel)
            contentLabel.numberOfLines = 0
            contentLabel.text = rawUserDataModel?.data
            contentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.scrollView)
                make.left.right.equalTo(self.view)
                make.width.equalTo(self.scrollView)
                make.bottom.equalTo(-10)
            }
        }
    }
}

extension FullScreenViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if let contentType = rawUserDataModel?.contentType(), contentType == ContentType.image {
            return imageView
        }
        return nil
    }
}
