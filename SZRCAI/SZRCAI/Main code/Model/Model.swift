import UIKit

protocol ModelDelegate: AnyObject {
    func deselectPin(pin: PinAnnotation)
    func modelButtonExecute(sender: UIButton)
}

@objc class Model: NSObject {
    
    public static let shared = Model()
    weak var trackingButton: UIButton!
    
    @objc dynamic var mainButton: UIButton?
    @objc dynamic var clearButton: UIButton?
    
    weak var delegate: ModelDelegate?
    
    @objc dynamic var graphsBuilt: Bool = false
    @objc dynamic var pins: [PinAnnotation] = []
    
    @objc dynamic var selected: PinAnnotation?
    public var route: [PinAnnotation] = []
    
    var selectedPinsKVO: NSKeyValueObservation!
    var mainButtonTitle: String = "" // To save the button name
    
    fileprivate override init() {
        super.init()
        mainButtonSetup()
        clearButtonSetup()
        selectedPinsKVO = observe(\.selected, options: .new, changeHandler: { [self] model, change in
            guard let newValue = change.newValue else { return }
            if newValue != nil {
                guard mainButton?.tag == Model.buttonTag.start.rawValue ||
                        mainButton?.tag == Model.buttonTag.finish.rawValue else { return }
                mainButton?.setTitle("OK", for: .normal)
            } else {
                guard mainButton?.tag != Model.buttonTag.routecalc.rawValue else { return }
                mainButton?.setTitle(mainButtonTitle, for: .normal)
            }
        })
    }
}
