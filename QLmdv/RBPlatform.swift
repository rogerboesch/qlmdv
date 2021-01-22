
import Foundation

#if os(macOS)

import AppKit

typealias OSFloat = CGFloat
typealias OSSize = CGSize
typealias OSPoint = CGPoint
typealias OSRect = CGRect
typealias OSEdgeInsets = NSEdgeInsets
typealias OSImage = NSImage
typealias OSColor = NSColor
typealias OSFont = NSFont
typealias OSAffineTransform = CGAffineTransform
typealias OSContext = CGContext
typealias OSView = NSView
typealias OSTextView = NSTextView
typealias OSTextViewDelegate = NSTextViewDelegate
typealias OSTextFieldDelegate = NSTextFieldDelegate
typealias OSImageView = NSImageView
typealias OSScrollView = NSScrollView
typealias OSLabel = RBTextLabel
typealias OSField = NSTextField
typealias OSButton = NSButton

typealias OSPasteboard = NSPasteboard

class NSPasteboard {

    static func setText(_ text: String) {
    }

}

extension NSImage {
    
    class func make(cgImage: CGImage, size: CGSize) -> OSImage {
        let image = OSImage(cgImage: cgImage, size: size)
        return image
    }
    
    class func getImage(named name: String, folder: String? = nil) -> NSImage? {
        if folder == nil {
            return NSImage(named: name)
        }
        else {
            let bundle = Bundle.main
            if let path = bundle.path(forResource: name, ofType: "png", inDirectory: folder) {
                let image = NSImage(contentsOfFile: path)
                return image
            }
            
            return nil
        }
    }
    
    class func getImage(path: String) -> NSImage? {
        let image = NSImage(contentsOfFile: path)
        return image
    }

}

extension NSImage {
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
 
    func pngWrite(to url: URL) -> Bool {
        do {
            try pngData?.write(to: url, options: .atomic)
            return true
        }
        catch {
            rbWarning("Cant save image")
            return false
        }
    }
    
    class func load(url: URL) -> NSImage? {
        return NSImage(contentsOf: url)
    }

}

extension NSView {
	
	func setBackgroundColor(_ color: OSColor) {
		self.wantsLayer = true;
		self.layer?.backgroundColor = color.cgColor;
	}
	
	func setAlphaFactor(_ value: OSFloat) {
		self.alphaValue = value
	}

	func setBorder(left: OSFloat, top: OSFloat, right: OSFloat, bottom: OSFloat) {
	}
    
    class func animate(withDuration duration: TimeInterval, animations: @escaping () -> Void) {
        animations()
    }

}

extension NSTextView {
    
    func setFrame(_ frame: OSRect) {
        self.frame = frame
        
        if let textContainer = self.textContainer {
            textContainer.containerSize = frame.size
        }
    }

    func setLineFragmentPadding(_ padding: OSFloat) {
        guard let textContainer = self.textContainer else { return }
        
        textContainer.lineFragmentPadding = padding
    }

    func setAttributedText(_ text: NSAttributedString?) {
        guard let storage = self.textStorage, let text = text else { return }
        
        storage.setAttributedString(text)
        self.needsLayout = true
    }

    func setContentInset(_ insets: OSEdgeInsets) {}

}

extension NSScrollView {
	
	func setBorderMargin(left: OSFloat, top: OSFloat, right: OSFloat, bottom: OSFloat) {
		self.setBorder(left: left, top: top, right: right, bottom: bottom)
	}

    func setContentSize(_ size: OSSize) {
        guard let documentView = self.documentView else { return }
        
        documentView.frame = OSRect.make(0, 0, size.width, size.height)
    }
    
}

extension NSImageView {

    func setAspectFit() {
        self.imageScaling = .scaleProportionallyUpOrDown
    }
    
}

extension NSTextField {

    func setText(_ string: String) {
        self.stringValue = string
    }
    
    func getText() -> String{
        return self.stringValue
    }
    
    func setDefaultStyle() { self.bezelStyle = .squareBezel }

}

extension NSButton {
    
    func setTitle(_ title: String) { self.title = title }
    func setImage(_ image: OSImage?) { self.image = image }
    func setTarget(_ target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
    func setDefaultStyle() { self.bezelStyle = .texturedSquare }
    func alignImageLeft() { self.imagePosition = .imageLeft }
    
}

#else

import UIKit

typealias OSFloat = CGFloat
typealias OSSize = CGSize
typealias OSPoint = CGPoint
typealias OSRect = CGRect
typealias OSEdgeInsets = UIEdgeInsets
typealias OSColor = UIColor
typealias OSImage = UIImage
typealias OSFont = UIFont
typealias OSAffineTransform = CGAffineTransform
typealias OSContext = CGContext
typealias OSView = UIView
typealias OSTextView = UITextView
typealias OSTextViewDelegate = UITextViewDelegate
typealias OSImageView = UIImageView
typealias OSScrollView = UIScrollView
typealias OSLabel = UILabel
typealias OSField = UITextField
typealias OSButton = UIButton
typealias OSTextFieldDelegate = UITextFieldDelegate

typealias OSPasteboard = UIPasteboard

class UIPasteboard {

    static func setText(_ text: String) {

    }

}

extension UIImage {

    class func make(cgImage: CGImage, size: CGSize) -> OSImage {
		let image = OSImage(cgImage: cgImage)
		return image
	}

    class func load(url: URL) -> UIImage? {
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        }
        catch {
            return nil
        }
    }

    class func getImage(named name: String, folder: String? = nil) -> UIImage? {
        if folder == nil {
            return UIImage(named: name)
        }
        else {
            let bundle = Bundle.main
            if let path = bundle.path(forResource: name, ofType: "png", inDirectory: folder) {
                let image = UIImage(contentsOfFile: path)
            
                return image
            }
            
            return nil
        }
    }

    class func getImage(path: String) -> UIImage? {
        return nil
    }
    
    func pngWrite(to url: URL) -> Bool {
        do {
            if let data = self.pngData() {
                try data.write(to: url, options: .atomic)
                return true
            }
        }
        catch {
            rbWarning("Cant save image")
        }

        return false
    }

}

extension UIView {

	func setBackgroundColor(_ color: OSColor) {
		self.backgroundColor = color
	}
	
	func setAlphaFactor(_ value: OSFloat) {
		self.alpha = value
	}

}

extension UILabel {
	
	func setText(_ text: String) {
		self.text = text
	}
	
	func setCenter() {
        self.textAlignment = .center
	}
	
    func setLeft() {
        self.textAlignment = .left
    }

}

extension UITextView {
    
    func setFrame(_ frame: OSRect) {
        self.frame = frame
    }

    func setLineFragmentPadding(_ padding: OSFloat) {
        self.textContainer.lineFragmentPadding = padding
    }
    
    func setAttributedText(_ text: NSAttributedString?) {
        guard let text = text else { return }
        
        self.attributedText = text
    }
    
    func setContentInset(_ insets: OSEdgeInsets) {
        self.contentInset = insets
    }

}

extension UIScrollView {
	
	func setBorderMargin(left: OSFloat, top: OSFloat, right: OSFloat, bottom: OSFloat) {
		self.contentInset = OSEdgeInsets(top: top, left: left, bottom: bottom, right: right)
	}
    
    func setContentSize(_ size: OSSize) {
        self.contentSize = size
    }

}

extension UIImageView {

    func setAspectFit() {
        self.contentMode = .scaleAspectFit
    }
    
}

extension UITextField {

    func setText(_ string: String) {
        self.text = string
    }
    
    func getText() -> String {
        guard let text = self.text else { return "" }
        return text
    }
    
    func setDefaultStyle() {  }

}

extension UIButton {
    func setTitle(_ title: String) { self.setTitle(title, for: .normal) }
    func setImage(_ image: OSImage?) { self.setImage(image, for: .normal) }
    func setTarget(_ target: AnyObject, action: Selector) { self.addTarget(target, action: action, for: .touchUpInside)}
    func setDefaultStyle() {  }
    func alignImageLeft() {}
}

#endif

typealias textDidChangeCallback = () -> Void

// MARK: - Extended platform independent text view

class RBOSTextView : OSTextView, OSTextViewDelegate {
    var textDidChange: textDidChangeCallback?

#if os(macOS)
    func getText() -> String {
        return self.string
    }

    func setText(_ string: String) {
        self.string = string
    }

    override func didChangeText() {
        if textDidChange != nil {
            textDidChange?()
        }
    }
#else
    func getText() -> String {
        return self.text
    }

    func setText(_ string: String) {
        self.text = string
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" {
            // User presses backspace
            textView.deleteBackward()
        }
        else {
            textView.insertText(text.uppercased())
        }
        
        if textDidChange != nil {
            textDidChange?()
        }

        return false
    }

#endif
}
