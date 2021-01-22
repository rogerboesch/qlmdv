
import Foundation
import AppKit

class RBOSView : OSView {

#if os(macOS)
    

    private var _tag = -1
    
    override var tag: Int {
        get {
            return _tag
        }
        set {
            _tag = newValue
        }
    }
    
    override var frame: OSRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
            layoutSubviews()
        }
    }

    var backgroundColor: OSColor? {
        didSet {
            if let color = backgroundColor {
                self.wantsLayer = true;
                self.layer?.backgroundColor = color.cgColor
            }
        }
    }
    
    var alpha: OSFloat = 1.0 {
        didSet {
            if alpha > 0.1 {
                isHidden = false
            }
            else {
                isHidden = true
            }
        }
    }

    override func resizeSubviews(withOldSize oldSize: OSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        layoutView()
    }
    
    func redrawView() {
        super.setNeedsDisplay(self.bounds)
    }
    
    func layoutSubviews() {}

    override var isFlipped: Bool {
        return true
    }
	
    @objc func handleClick(_ gestureRecognizer: NSClickGestureRecognizer) {
        let location: OSPoint = gestureRecognizer.location(in: self)
        processTap(location)
    }

    func installTapHandler() {
        let click = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
		self.addGestureRecognizer(click)
	}
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
#else

    override func layoutSubviews() {}
    
    func redrawView() {
        super.setNeedsDisplay()
    }

    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location: OSPoint = gestureRecognizer.location(in: self)
        processTap(location)
    }

    func installTapHandler() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.gestureRecognizers = [tapGesture]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

#endif

    func layoutView() {}
    func processTap(_ location: OSPoint) {}

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
