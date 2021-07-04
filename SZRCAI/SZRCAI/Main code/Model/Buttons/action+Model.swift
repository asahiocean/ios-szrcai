import UIKit

/// - Tag: action
extension Model {
    /// [Method](x-source-tag://action) that determines what will happen when the button is pressed
    /// - Parameter sender: where will you need to get `.tag`
    @objc func buttonAction(_ sender: UIButton?) {
        guard let button = sender else { return }
        
        // MARK: Delegate for further actions
        delegate?.modelButtonExecute(sender: button)
        
        // MARK: Animate + configuration switch
        func switching(next type: buttonTag) {
            DispatchQueue.main.async {
                button.transform = .init(scaleX: 0.9, y: 0.9)
                UIView.animate(withDuration: 0.25, animations: {
                    button.transform = .identity
                }, completion: { [self] _ in
                    buttonAnimator(b: button, {
                        buttonConfig(type: type)
                    })
                })
            }
        }
        
        func buttonAnimator(b button: UIButton, _ completion: (() -> Void)? = nil) {
            // simple animator for positioning button on the screen
            UIView.animate(withDuration: 0.25, delay: 0.25, options: [.curveEaseInOut], animations: {
                button.frame.origin.y += 200
                button.layoutIfNeeded()
            }, completion: { _ in
                completion?()
                UIView.animate(withDuration: 0.25, animations: {
                    button.frame.origin.y -= 200
                    button.layoutIfNeeded()
                })
            })
        }
        
        func check(pin point: inout PinAnnotation?, cl: UIColor?, _ closure: @autoclosure () -> ()) {
            guard let pin = point else {
                button.shake()
                return
            }
            if let color = cl { pin.markerColor = color }
            delegate?.deselectPin(pin: pin)
            route.append(pin)
            point = nil // deleting the value the selected point
            closure()
        }
        
        let tag = Model.buttonTag(rawValue: button.tag)
        switch tag {
        case .graphs:
            if graphsBuilt { switching(next: .start) }
        case .start:
            check(pin: &selected, cl: #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1), {
                switching(next: .finish)
            }())
        case .finish:
            check(pin: &selected, cl: #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1), {
                switching(next: .routecalc)
            }())
        case .clear:
            switching(next: .graphs)
        default:
            break
        }
    }
}
