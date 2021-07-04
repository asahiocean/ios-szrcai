import UIKit.UIResponder

extension UIResponder {
    static func defaultViewController(for window: UIWindow?) {
        guard let window = window else { fatalError() }
        window.rootViewController = ViewController(nibName: nil, bundle: nil)
        if #available(iOS 13.0, *) {
            window.backgroundColor = .systemBackground
        } else {
            window.backgroundColor = .white
        }
        window.makeKeyAndVisible()
    }
}
