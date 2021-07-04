import UIKit

extension UIButton {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = .init(name: .linear)
        animation.duration = 0.5
        animation.values = [-15,15,-15,15,-5,5,-2.5,2.5,0]
        layer.add(animation, forKey: "shake")
    }
}
