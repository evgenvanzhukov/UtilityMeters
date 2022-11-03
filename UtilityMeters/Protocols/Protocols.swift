import Foundation
import UIKit

protocol CreateAble {
    static func createObject() -> Self
}

protocol Coordinator {
    
    var navigationControoler: UINavigationController { get set }
    
    func start()
    
    func eventOccured(with event: EventType)
}
