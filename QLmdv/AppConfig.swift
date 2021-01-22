
import Foundation

// Actions for RBObsserver
enum ObserverAction {
    case click, doubleClick
    case fileChanged, fileSaved
}

// Sender tags for RBObsserver
enum ObserverTag {
    case none
    case fileView, mdvView, editor
}

struct App {

    struct Config {
    }
    
    struct Color {
        static let toolbarDelimiter = OSColor(hexString: "#C6C6C9")
        static let navigationBar = OSColor(hexString: "#302f36")
        static let navigationBarTitle = OSColor(hexString: "#ffffff")
        static let viewBackground = OSColor(hexString: "#292a2F")
        static let errorBackground = OSColor(hexString: "#D70000")
        static let errorForeground = OSColor(hexString: "#ffffff")
    }
    
    struct Font {
        static let normal = OSFont(name: "Menlo", size: 12)!
        static let bold = OSFont(name: "Menlo-Bold", size: 12)!
    }

    struct Toolbar {
        static let color = OSColor(hexString: "#302f36")
        static let height: OSFloat = 30
    }
}

