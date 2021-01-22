
import Foundation

#if os(macOS)
    import AppKit

    extension OSEdgeInsets {

        static var zero: OSEdgeInsets {
            return OSEdgeInsets()
        }

    }

#endif

extension OSFloat {
    var radian: OSFloat {
        return OSFloat(self) * .pi / 180
    }
}

extension OSSize {
    var center: OSPoint {
        return OSPoint(x: self.width/2, y: self.height/2)
    }

    static func make(_ x: OSFloat, _ y: OSFloat) -> OSSize {
        return OSSize(width: x, height: y)
    }
}

extension OSPoint {
    static func make(_ x: Int, _ y: Int) -> OSPoint {
        return OSPoint(x: OSFloat(x), y: OSFloat(y))
    }
    static func make(_ x: OSFloat, _ y: OSFloat) -> OSPoint {
        return OSPoint(x: x, y: y)
    }

    func translate(by distance: OSFloat, angle: OSFloat) -> OSPoint {
        let transform = OSAffineTransform(translationX: x, y: y).rotated(by: angle.radian)
        return OSPoint(x: -distance, y: 0).applying(transform)
    }
}

extension OSRect {
    static func make(_ x: OSFloat, _ y: OSFloat, _ width: OSFloat, _ height: OSFloat) -> OSRect {
        return OSRect(x: x, y: y, width: width, height: height)
    }

#if os(iOS)

    func fill() {
        UIRectFill(self)
    }
	
    func stroke(_ width: OSFloat = 1) {
        let path = UIBezierPath(rect: self)
        path.lineWidth = width
        path.stroke()
    }

#endif

#if os(macOS)
    
    func fill() {
        let path = NSBezierPath(rect: self)
        path.fill()
    }

    func stroke(_ width: OSFloat = 1) {
        let path = NSBezierPath(rect: self)
        path.lineWidth = width
        path.stroke()
    }

#endif
    
    var widthHalf : OSFloat {
        return self.size.width / 2
    }
    
    var widthOneThird : OSFloat {
        return self.size.width / 3
    }
    
    var widthTwoThird : OSFloat {
        return self.size.width / 3 * 2
    }
    
    var heightHalf : OSFloat {
        return self.size.height / 2
    }
    
    var heightOneThird : OSFloat {
        return self.size.height / 3
    }
    
    var heightTwoThird : OSFloat {
        return self.size.height / 3 * 2
    }
    
    var leftHalf : OSRect {
        return OSRect.make(self.origin.x, self.origin.y, widthHalf, self.size.height)
    }
    
    var rightHalf : OSRect {
        return OSRect.make(widthHalf, self.origin.y, widthHalf, self.size.height)
    }
    
    var leftTop : OSRect {
        return OSRect.make(self.origin.x, self.origin.y, widthHalf, heightHalf)
    }
    
    var leftBottom : OSRect {
        return OSRect.make(self.origin.x, heightHalf, widthHalf, heightHalf)
    }
    
    var rightTop : OSRect {
        return OSRect.make(widthHalf, self.origin.y, widthHalf, heightHalf)
    }
    
    var rightBottom : OSRect {
        return OSRect.make(widthHalf, heightHalf, widthHalf, heightHalf)
    }
    
    var topHalf : OSRect {
        return OSRect.make(self.origin.x, self.origin.y, self.size.width, heightHalf)
    }
    
    var bottomHalf : OSRect {
        return OSRect.make(self.origin.x, self.origin.y+heightHalf, self.size.width, heightHalf)
    }

    var topThird : OSRect {
        return OSRect.make(self.origin.x, self.origin.y, self.size.width, heightOneThird)
    }
    
    var middleThird : OSRect {
        return OSRect.make(self.origin.x, self.origin.y+heightOneThird, self.size.width, heightOneThird)
    }
    
    var bottomThird : OSRect {
        return OSRect.make(self.origin.x, self.origin.y+2*heightOneThird, self.size.width, heightOneThird)
    }
    
    func moveX(_ offset: OSFloat) -> OSRect {
        return OSRect.make(self.origin.x+offset, self.origin.y, self.size.width, self.size.height)
    }
    
    func moveY(_ offset: OSFloat) -> OSRect {
        return OSRect.make(self.origin.x, self.origin.y+offset, self.size.width, self.size.height)
    }

}
