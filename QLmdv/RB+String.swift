
import Foundation

extension String {
    
    subscript(index: Int) -> UnicodeScalar {
        return unicodeScalars[unicodeScalars.index(unicodeScalars.startIndex, offsetBy: index)]
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }

    func charAt(_ index: Int) -> String {
        let charSequence = self.unicodeScalars.map{ Character($0) }
        let ch = charSequence[index]
        return String(ch)
    }

    func drawVerticallyCentered(in rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
		let size = self.size(withAttributes: attributes)
		let centeredRect = CGRect(x: rect.origin.x, y: rect.origin.y + (rect.size.height-size.height)/2.0, width: rect.size.width, height: size.height)
		self.draw(in: centeredRect, withAttributes: attributes)
	}

}

extension UnicodeScalar {
    
    var isLetter: Bool {
        return CharacterSet.letters.contains(self)
    }

	var isText: Bool {
		if isLetter {
			return true
		}
		
		if isDigit {
			return true
		}

		if CharacterSet(charactersIn: "!$%&/=?*;:_.-@# ").contains(self) {
			return true
		}
		
		return false
    }

    var isWhiteSpace: Bool {
        return CharacterSet.whitespacesAndNewlines.contains(self)
    }
    
    var isDigit: Bool {
        return CharacterSet.decimalDigits.contains(self)
    }
}

extension String {
    var fileURL: URL {
        return URL(fileURLWithPath: self)
    }

    func appendingPathComponent(_ string: String) -> String {
        return fileURL.appendingPathComponent(string).path
    }

    var lastPathComponent:String {
        get {
            return fileURL.lastPathComponent
        }
    }

   var deletingPathExtension: String {
    return fileURL.deletingPathExtension().path
   }
}
