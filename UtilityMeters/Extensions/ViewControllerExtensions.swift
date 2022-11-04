
import UIKit

extension CreateAble where Self : UIViewController {
    
    /// Создает экземпляр  контроллера
    static func createObject() -> Self {
        let id = String(describing: self)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        return sb.instantiateViewController(identifier: id) as! Self
    }
}

extension UIViewController {
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
