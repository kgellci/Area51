import UIKit

struct NavigationRouter {
    static var mainNavigation: UITabBarController {
        let feedController = UIStoryboard.feed.instantiateInitialViewController()!
        feedController.tabBarItem = UITabBarItem(title: "Feed", image: nil, tag: 0)

        let settingsController = UIStoryboard.settings.instantiateInitialViewController()!
        settingsController.tabBarItem = UITabBarItem(title: "Settings", image: nil, tag: 0)

        let tabBar = UITabBarController()
        tabBar.viewControllers = [feedController, settingsController]
        return tabBar
    }
}
