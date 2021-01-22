
import Foundation

func getRandomNumberBetween(_ from: Int, _ to: Int) -> Int {
    let value = from + Int(arc4random()) % (to-from+1);
    return value;
}

// -----------------------------------------------------------------------------
// MARK: - NSTimer replacment

typealias RepeatClosure = () -> ()

public class Repeat {
    
    static func once(after timeInterval: TimeInterval, _ closure: @escaping RepeatClosure) {
        let when = DispatchTime.now() + timeInterval
        DispatchQueue.main.asyncAfter(deadline: when) {
            closure()
        }
    }
    
}

// -----------------------------------------------------------------------------
// MARK: - Async shortcut

typealias AsynchronousClosure = () -> ()

public class Asynchronous {
    
    static func execute(_ closure: @escaping AsynchronousClosure) {
        DispatchQueue.global().async {
            closure()
        }
    }
    
    static func executeOnUI(_ closure: @escaping AsynchronousClosure) {
        DispatchQueue.main.async {
            closure()
        }
    }

}

// -----------------------------------------------------------------------------

extension OSColor {
	
    convenience init(hexString: String, _ alpha: OSFloat = 1.0) {
        var hex = hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString

        guard hex.count == 3 || hex.count == 6 else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: alpha)
            return
        }

        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }

        let number = Int(hex, radix: 16)!
        let red = OSFloat((number >> 16) & 0xFF) / 255.0
        let green = OSFloat((number >> 8) & 0xFF) / 255.0
        let blue = OSFloat(number & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    internal func rgbComponents() -> [OSFloat] {
        var (r, g, b, a): (OSFloat, OSFloat, OSFloat, OSFloat) = (0.0, 0.0, 0.0, 0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return [r, g, b]
    }
    
    var isDark: Bool {
        let RGB = rgbComponents()
        return (0.2126 * RGB[0] + 0.7152 * RGB[1] + 0.0722 * RGB[2]) < 0.5
    }

}
