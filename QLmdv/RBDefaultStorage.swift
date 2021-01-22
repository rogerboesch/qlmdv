
import Foundation

enum RBDefaultStoreKey : String {
    case projectPath
}

class RBDefaultStore {
    static func getNewID(key: String) -> Int32 {
        let defaults = UserDefaults.standard
        var value = defaults.double(forKey: key)
        value += 1
        
        defaults.set(value, forKey: key)
        defaults.synchronize()
        
        return Int32(value);
    }
    
    static func getID(key: String) -> Int32 {
        let defaults = UserDefaults.standard
        let value = defaults.double(forKey: key)
        
        return Int32(value);
    }
    
    static func getLastProjectPath() -> String? {
        let key = RBDefaultStoreKey.projectPath.rawValue

        let defaults = UserDefaults.standard
        let value = defaults.string(forKey: key)
        
        return value;
    }
    
    @discardableResult
    static func setLastProjectPath(path: String) -> Bool {
        let key = RBDefaultStoreKey.projectPath.rawValue

        let defaults = UserDefaults.standard
        defaults.set(path, forKey: key)
        defaults.synchronize()
        
        return true;
    }

    
}
