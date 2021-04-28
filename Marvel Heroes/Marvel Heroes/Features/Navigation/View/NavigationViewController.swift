//
//  NavigationViewController.swift
//  Marvel Heroes
//
//  Created by César Ferreira on 24/04/21.
//

import UIKit

class NavigationViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.setupTabBar()
    }

    private func setupTabBar() {
        // Create Tab one
        let tabOne = CharactersViewController.instantiateViewController()
        tabOne.isRemote = true
        let navigationControllerOne = UINavigationController(rootViewController: tabOne)
        let tabOneBarItem = UITabBarItem(title: "Lista", image: UIImage(systemName: "list.dash"), selectedImage: UIImage(systemName: "list.dash"))
        tabOne.tabBarItem = tabOneBarItem

        // Create Tab two
        let tabTwo = CharactersViewController.instantiateViewController()
        tabTwo.isRemote = false
        let navigationControllerTwo = UINavigationController(rootViewController: tabTwo)
        let tabTwoBarItem = UITabBarItem(title: "Favoritos", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        tabTwo.tabBarItem = tabTwoBarItem

        self.viewControllers = [navigationControllerOne, navigationControllerTwo]
    }
}
