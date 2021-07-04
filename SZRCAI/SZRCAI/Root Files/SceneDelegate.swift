import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    internal var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { fatalError("UIScene nil") }
        switch UIApplication.shared.delegate as? AppDelegate {
        case nil:
            window = UIWindow(windowScene: windowScene)
            Self.defaultViewController(for: window)
        case let delegate:
            delegate?.window?.windowScene = windowScene
            self.window = delegate?.window
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
