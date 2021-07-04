import UIKit

extension ViewController {
    internal func buttonsSetup() {
        guard let tracker = mapView.model.trackerButton(with: mapView) else { fatalError("Solve the button problem") }
        view.addSubview(tracker)
        
        buttonKVO = mapView.model.observe(\.mainButton, options: [.initial,.new], changeHandler: { obj, change in
            guard let config = change.newValue, let button = config else { return }
            self.mainButton = button // Monitoring the state of the button through the KVO
        })
        view.addSubview(mainButton)
        
        if let button = mapView.model.clearButton {
            DispatchQueue.main.async {
                // For an acceptable location of the button on the screen
                button.center.x = tracker.center.x
                button.center.y = self.mainButton.center.y
            }
            clearButton = button
            view.addSubview(clearButton)
        }
    }
    
    internal func pinsKVOFunc() {
        enum state: CGFloat { case show = 0.9, hide = 1 }
        
        // Simple animation of button positions
        func buttonsAnimator(state: state) {
            let value = view.bounds.maxY * state.rawValue
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
                // - - Main button - -
                self?.mainButton.frame.origin.y = value
                self?.mainButton.layoutIfNeeded()
                //  - - Clear button - -
                self?.clearButton.frame.origin.y = value
                self?.clearButton.layoutIfNeeded()
            })
        }
        
        pinsKVO = mapView.model.observe(\.pins, options: .new, changeHandler: { [self] obj, change in
            guard let pins = change.newValue else { return }
            
            // MARK: Условие!
            // После добавления хотя бы 3 точек должны появляться кнопки
            if pins.count > 2 {
                buttonsAnimator(state: .show)
            } else {
                guard !mapView.model.graphsBuilt else { return }
                buttonsAnimator(state: .hide)
            }
        })
    }
}
