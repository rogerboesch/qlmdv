
import AppKit

class RBTextLabel : NSView {
    private var _text = ""
    private var _tag = -1

    override var tag: Int {
        get {
            return _tag
        }
        set {
            _tag = newValue
        }
    }
    
    var text = "" {
        didSet {
            setText(text)
        }
    }
    
    var centered = true {
        didSet {
            self.needsDisplay = true
        }
    }

    var font: OSFont = OSFont.systemFont(ofSize: 12) {
        didSet {
            self.needsDisplay = true
        }
    }
    
    var textColor = OSColor.black {
        didSet {
            self.needsDisplay = true
        }
    }
    
    var backgroundColor = OSColor.clear {
        didSet {
			self.wantsLayer = true;
			self.layer?.backgroundColor = backgroundColor.cgColor;

            self.needsDisplay = true
        }
    }

    func setText(_ text: String) {
        _text = text
        self.needsDisplay = true
    }
    
    func setCenter() {}
    func setLeft() {
        self.centered = false
    }

    override var isFlipped: Bool {
        return true
    }

    override func draw(_ dirtyRect: NSRect) {
        let paragraphStyle = NSMutableParagraphStyle()
        
        if self.centered {
            paragraphStyle.alignment = .center
        }
        else {
            paragraphStyle.alignment = .left
        }
        
        let attributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor : textColor
        ]

        let rect = self.bounds

        _text.drawVerticallyCentered(in: rect, withAttributes: attributes)
    }

}
