import UIKit

struct NavigationRouter {
    static var mainNavigation: UITabBarController {
        let feedController = UIStoryboard.feed.instantiateInitialViewController()!
        feedController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "TabbarFeedIcon"), tag: 0)

        let settingsController = UIStoryboard.settings.instantiateInitialViewController()!
        settingsController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "TabbarSettingsIcon"), tag: 0)

        let tabBar = UITabBarController()
        tabBar.viewControllers = [feedController, settingsController]
        return tabBar
    }
}
