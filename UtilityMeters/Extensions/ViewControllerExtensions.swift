
import UIKit
import CoreData

extension CreateAble where Self : UIViewController {
    
    /// Создает экземпляр  контроллера
    static func createObject() -> Self {
        let id = String(describing: self)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        return sb.instantiateViewController(identifier: id) as! Self
    }
}

extension UIViewController {
    
//    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
}

extension Array where Element == Meter {
    func first(_ type: MeterType) -> Meter? {
        // TODO: 
        return first(where: {$0.type == type.rawValue})
    }
}
