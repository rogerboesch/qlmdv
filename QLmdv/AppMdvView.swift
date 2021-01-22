
import Foundation

class AppMdvView : RBTreeView {

    // MARK: - Initialisation

    override init(frame: NSRect) {
        super.init(frame: frame)

        self.observerTag = .mdvView
        setHeader("No mdv file selected")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
