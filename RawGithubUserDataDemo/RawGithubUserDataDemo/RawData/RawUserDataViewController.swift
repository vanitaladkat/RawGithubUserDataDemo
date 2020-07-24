//
//  RawUserDataViewController.swift
//  RawGithubUserDataDemo
//
//  Created by Vanita Ladkat on 21/07/20.
//  Copyright © 2020 Vanita Ladkat. All rights reserved.
//

import UIKit
import SnapKit

class RawUserDataViewController: UIViewController {

    lazy var userDataTableView = UITableView()

    let viewModel = RawUserDataViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getRawGithubUserData()
    }
    
    func setUpUI() {
        self.navigationItem.title = "Raw user data"
        view.addSubview(userDataTableView)
        userDataTableView.register(TextTableViewCell.self, forCellReuseIdentifier: "TextTableViewCell")
        userDataTableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
        userDataTableView.delegate = self
        userDataTableView.dataSource = self
        userDataTableView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func updateUI() {
        userDataTableView.reloadData()
    }

    func getRawGithubUserData() {
        viewModel.getRawGithubUserData { [weak self] (success, error) in
            if success {
                self?.updateUI()
            } else {
                self?.showFailureAlert(error: error)
            }
        }
    }

    private func showFailureAlert(error: Error?) {
        let message = error?.localizedDescription ?? "Failed to get data"
        let alert = UIAlertController(title: "Failed", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] (action) in
            self?.getRawGithubUserData()
        }
        alert.addAction(okAction)
        alert.addAction(retryAction)
        present(alert, animated: true, completion: nil)
    }

}

extension RawUserDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = viewModel.type(at: indexPath.row)
        switch type {
        case .image:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as? ImageTableViewCell {
                let imgUrl = viewModel.data(at: indexPath.row) ?? ""
                cell.contentImageView.setImage(from: imgUrl, placeHolder: nil) { (img) in
                    cell.layoutIfNeeded()
                }
                cell.timeLabel.text = viewModel.date(at: indexPath.row)
                return cell
            }
        case .text:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell") as? TextTableViewCell {
                cell.contentLabel.text = viewModel.data(at: indexPath.row)
                cell.timeLabel.text = viewModel.date(at: indexPath.row)
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = viewModel.type(at: indexPath.row)
        switch type {
        case .image:
            return 350
        case.text:
            return 100
        default:
            break
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fullScreenViewController = FullScreenViewController()
        fullScreenViewController.rawUserDataModel = viewModel.rawUserDataModel(at: indexPath.row)
        navigationController?.pushViewController(fullScreenViewController, animated: true)
    }
}
