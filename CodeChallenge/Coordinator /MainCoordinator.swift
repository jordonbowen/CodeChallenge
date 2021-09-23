//
//  MainCoordinator.swift
//  CodeChallenge
//
//  Created by Jordon Bowen on 9/22/21.
//

import UIKit

protocol Coordinator:AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {

        let vc = RedditFeedsViewController()
        vc.viewModel = RedditFeedViewModel()
        navigationController.pushViewController(vc, animated: false)
    }

}
