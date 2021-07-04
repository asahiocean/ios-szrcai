import UIKit

// Тестовое задание «СЗ РЦАИ» iOS Developer

class ViewController: UIViewController {
    
    var mapView: MapView!
    
    /// Button for building graphs and routes
    weak var mainButton: UIButton!
    weak var clearButton: UIButton!
    
    internal var buttonKVO: NSKeyValueObservation!
    internal var pinsKVO: NSKeyValueObservation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = .init(frame: view.frame)
        mapView.delegate = self
        view.addSubview(mapView)
        
        mapView.model.delegate = self
        
        buttonsSetup()
        pinsKVOFunc()
    }
}
