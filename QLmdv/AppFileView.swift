
import Foundation

class AppFileView : RBTreeView {
    
    // MARK: - Initialisation

    override init(frame: NSRect) {
        super.init(frame: frame)

        self.observerTag = .fileView
        setHeader("Directories")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
