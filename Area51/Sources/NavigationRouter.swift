import UIKit

struct NavigationRouter {
    static var mainNavigation: UITabBarController {
        let feedController = UIStoryboard.feed.instantiateInitialViewController()!
        let feedIcon = UIImage(named: "TabbarFeedIcon")
        feedController.tabBarItem = UITabBarItem(title: "Feed", image: feedIcon, tag: 0)

        let settingsController = UIStoryboard.settings.instantiateInitialViewController()!
        let settingsIcon = UIImage(named: "TabbarSettingsIcon")
        settingsController.tabBarItem = UITabBarItem(title: "Settings", image: settingsIcon, tag: 0)

        let tabBar = UITabBarController()
        tabBar.viewControllers = [feedController, settingsController]
        return tabBar
    }
}
