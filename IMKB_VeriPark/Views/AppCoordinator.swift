
import UIKit

class AppCoordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let vc = OnboardingVC()
        let nav = UINavigationController(rootViewController: vc)
        window.rootViewController = nav
        window.rootViewController?.view.backgroundColor = .systemBackground
        window.makeKeyAndVisible()
    }
}
