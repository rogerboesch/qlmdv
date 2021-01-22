
class AppEditorView: RBOSView {
    private var _editor: MyEditorView!
    private var _toolbar: RBToolbar!
    private var _changed = false
    private var _filename = ""
    
    // MARK: - Properties
    
    var fileChanged : Bool {
        return _changed
    }
    
    // MARK: - Helper
    private func getFileExtensionQL(_ filename: String) -> (String, String) {
        let parts = filename.components(separatedBy: "_")
        if parts.count > 1 {
            return (parts[0], parts[1])
        }
        else {
            return (filename, "")
        }
    }

    // MARK: - UI

    private func updateUI() {
        _editor.isHidden = _filename.count > 0 ? false : true
        
        if _filename.count == 0 {
            _toolbar.setItemText("No file selected", name: "filename")
        }
        else {
            if _changed {
                _toolbar.setItemText("\(_filename) *", name: "filename")
            }
            else {
                _toolbar.setItemText("\(_filename)", name: "filename")
            }
        }
    }

    // MARK: - Content

    func contentHasChanged() {
        _changed = true;
        updateUI()
    }

    func selectLineNumber(_ number: Int) {
        _editor.selectLine(withNumber: Int32(number), color: App.Color.errorForeground, background: App.Color.errorBackground)
    }
    
    func setEmptyContent() {
        _filename = ""
        updateUI()
    }
    
    // MARK: - File handling

    func loadFile(_ path: String, filename: String) {
        let content = RBFileUtility.loadString(path: path)
        
        let (name, ext) = getFileExtensionQL(filename)
        _editor.setSource(content, name: name, extension: ext)

        _filename = filename
        updateUI()
    }

    func saveFile(_ filename: String) {
        guard let content = _editor.getText() else { return }

        RBFileUtility.saveString(content, path: filename)

        _changed = false
        updateUI()
    }

    // MARK: - Initialisation

    override func layoutSubviews() {
        var rect = self.bounds
        rect.size.height = App.Toolbar.height
        _toolbar.frame = rect
        
        rect = self.bounds
        rect.origin.y += App.Toolbar.height + 6
        rect.size.height -= App.Toolbar.height - 6
        _editor.frame = rect
    }

    override init(frame: OSRect) {
        super.init(frame: frame)

        _editor = MyEditorView(frame: self.bounds)
        self.addSubview(_editor)
        
        _toolbar = RBToolbar(parent: self)
        _toolbar.addItem(name: "filename", title: "", icon: nil, width: 250) { (action, sender) in
        }
        
        _editor.callback = {
            self.contentHasChanged()
            self.notify(with: .fileChanged, tag: .editor)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

typealias EditorCallback = () ->()

class MyEditorView : RBEditorView {
    var callback: EditorCallback?
    
    override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
        
        if callback != nil {
            callback!()
        }
    }
}
