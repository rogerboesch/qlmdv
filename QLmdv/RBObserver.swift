
import Foundation

typealias ObserverCallback = (ObserverAction, ObserverTag) ->()
typealias ObserverCallbackList = Array<ObserverCallback>
typealias ObserverList = Array<RBObserver>

extension NSObject {
    static var observables = Dictionary<ObserverAction, ObserverList>()
    static var callbacks = Dictionary<ObserverAction, ObserverCallbackList>()

    // MARK: - Register/unregister observer
    
    func register(for action: ObserverAction, observer: RBObserver) {
        if var observers = NSObject.observables[action] {
            observers.append(observer)
            NSObject.observables[action] = observers
        }
        else {
            var observers = ObserverList()
            observers.append(observer)
            
            NSObject.observables[action] = observers
        }
        
        rbDebug("Register observer '\(observer)' for action '\(action)' ")
    }

    func register(for action: ObserverAction, callback: @escaping ObserverCallback) {
        if var callbacks = NSObject.callbacks[action] {
            callbacks.append(callback)
            NSObject.callbacks[action] = callbacks
        }
        else {
            var callbacks = ObserverCallbackList()
            callbacks.append(callback)
            
            NSObject.callbacks[action] = callbacks
        }
        
        rbDebug("Register callback '\(String(describing: callback))' for action '\(action)' ")
    }

    func unregister() {
        rbDebug("Unregister() not imlemented")
    }

    // MARK: - Notify with an action
    
    func notify(with action: ObserverAction, tag: ObserverTag) {
        if let observers = NSObject.observables[action] {
            rbDebug("Notify \(observers.count) observer(s) by '\(tag)' with action '\(action)' ")

            for observer in observers {
                observer.onReceive(action: action, with: tag)
            }
        }
        
        if let callbacks = NSObject.callbacks[action] {
            rbDebug("Notify \(callbacks.count) callback(s) by '\(tag)' with action '\(action)' ")

            for callback in callbacks {
                callback(action, tag)
            }
        }
    }

}

protocol RBObserver {
    func onReceive(action: ObserverAction, with tag: ObserverTag)
}
