import Foundation
import UIKit

protocol CreateAble {
    static func createObject() -> Self
}

protocol Coordinator: class {
    
    var navigationControoler: UINavigationController { get set }
    
    func start()
    
    func eventOccured(with event: EventType)
}

protocol Sharing: class {
    func share(_ model: AnyObject?)
}
