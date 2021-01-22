
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate, NSSplitViewDelegate {
    private var _window: NSWindow!
    private var _menu: NSMenu!
    private var _toolbar: RBNSToolbar!

    private var _splitView1: MySplitView!
    private var _fileView: AppFileView!
    private var _mdvView: AppMdvView!
    private var _editorView: AppEditorView!

    private var _path = RBFileUtility.homePath()
    private var _temporaryPath = NSTemporaryDirectory() + "com.rogerboesch.qlmdv/"

    private var _mdvFilename: String?
    private var _contentFilename: String?

    // MARK: - Properties
    
    var window: NSWindow {
        get {
            return _window
        }
        set(value) {
            _window = value
        }
    }
    
    var menu: NSMenu {
        get {
            return _menu
        }
        set(value) {
            _menu = value
        }
    }
    
    var toolbar: RBNSToolbar {
        get {
            return _toolbar
        }
        set(value) {
            _toolbar = value
        }
    }

    class var applicationName: String {
        get {
            if let key = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") {
                if let nameOfBundle = key as? String {
                    return nameOfBundle
                }
            }
            
            return "Unknown"
        }
    }

    class var applicationVersion: String {
        get {
            guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
            else { return "Unknown" }
            
            return "\(version)"
        }
    }

    class var applicationFullVersion: String {
        get {
            guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString"),
                  let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")
            else { return "Unknown" }
            
            return "\(version) - build \(build)"
        }
    }

    // MARK: - Alerts & File dialogs

    class func showAlert(_ text: String, title: String = "", field: String? = nil) -> (Bool, String?) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = text
        
        if field != nil {
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Cancel")
        }
        
        if field != nil {
            let textfield = NSTextField(frame: NSRect(x: 0.0, y: 0.0, width: 300.0, height: 24.0))
            textfield.alignment = .center
            textfield.stringValue = field!
            alert.accessoryView = textfield
        }
        
        let response = alert.runModal()
        if response != .alertFirstButtonReturn {
            return (false, nil)
        }
        
        if let field = alert.accessoryView as? NSTextField {
            rbDebug(field.stringValue)
            return (true, field.stringValue)
        }
        
        return (false, nil)
    }
    
    private func exportFile() {
        guard let contentFilename = _contentFilename else { return }
        
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = false
        savePanel.showsTagField = false
        savePanel.nameFieldStringValue = contentFilename
        savePanel.isExtensionHidden = false
        savePanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        savePanel.begin { (result) in
            if result == NSApplication.ModalResponse.OK {
                if let destUrl = savePanel.url {
                    let path = self._temporaryPath + contentFilename;
                    let sourceUrl = URL(fileURLWithPath: path)
                    
                    RBFileUtility.fileCopy(from: sourceUrl, to: destUrl)
                }
            }
        }
    }

    private func importFile() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = false
        //panel.allowedFileTypes = ["xxx"]
        
        let clicked = panel.runModal()

        if clicked == NSApplication.ModalResponse.OK {
            if let path = panel.url?.path {
                addFileToMdv(path)
            }
        }
    }

    class func showConfirmationAlert(_ text: String, title: String = "") -> Bool {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Yes")
        alert.addButton(withTitle: "No")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            return true
        }
        
        return false
    }

    class func showErrorAlert(_ text: String) {
        let alert = NSAlert()
        alert.messageText = "ERROR"
        alert.informativeText = text
        alert.alertStyle = .critical
        
        alert.runModal()
    }
    
    private func newMdvFile() {
        let text = "New Microdrive File:"
        let (result, filename) = AppDelegate.showAlert(text, field: "Untitled")
        
        if result && filename != nil {
            createMdv(filename!)
        }
    }

    // MARK: - Shared menu actions

    private func createToolbar() {
        self.toolbar = RBNSToolbar(name: "myToolbar")

        self.toolbar.addItem(name: "new", title: "New MDV", icon: OSImage.getImage(named: "Add"), width: 50) { (tag, sender) in
            self.newMdvFile()
        }
        self.toolbar.addItem(name: "add", title: "Add", icon: OSImage.getImage(named: "Insert"), width: 50) { (tag, sender) in
            self.importFile()
        }
        self.toolbar.addItem(name: "extract", title: "Extract", icon: OSImage.getImage(named: "Extract"), width: 50) { (tag, sender) in
            self.exportFile()
        }

        self.toolbar.addSpace(10)

        self.toolbar.addItem(name: "save", title: "Save", icon: OSImage.getImage(named: "Save"), width: 50) { (tag, sender) in
            self.saveCurrentFile()
        }

        self.toolbar.addSpace(10)

        self.toolbar.addSegment(name: "platform", title: "Sinclair QL", width: 80, [""], ["QLLogo"]) { (tag, sender) in
        }

        self.window.toolbar = self.toolbar
    }

    // MARK: - Create Menu

    private func createApplicationMenu(_ mainMenu: NSMenu, name: String) {
        let submenu = mainMenu.addItem(withTitle: "Application", action: nil, keyEquivalent: "")
        let menu = NSMenu(title: "Application")
        mainMenu.setSubmenu(menu, for: submenu)
        
        var menuItem = menu.addItem(withTitle: "About" + " " + name, action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
        menuItem.target = NSApp
        
        menu.addItem(NSMenuItem.separator())
        
        menuItem = menu.addItem(withTitle: "Services", action: nil, keyEquivalent: "")
        let servicesMenu = NSMenu(title: "Services")
        menu.setSubmenu(servicesMenu, for: menuItem)
        NSApp.servicesMenu = servicesMenu
        
        menu.addItem(NSMenuItem.separator())
        
        menuItem = menu.addItem(withTitle: "Hide" + " " + name, action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
        menuItem.target = NSApp
        
        menuItem = menu.addItem(withTitle: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
        menuItem.keyEquivalentModifierMask = [.command, .option]
        menuItem.target = NSApp
        
        menuItem = menu.addItem(withTitle: "Show all", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
        menuItem.target = NSApp
        
        menu.addItem(NSMenuItem.separator())
        
        menuItem = menu.addItem(withTitle:"Quit" + " " + name, action:#selector(NSApplication.terminate(_:)), keyEquivalent:"q")
        menuItem.target = NSApp
    }
    
    private func createFileMenu(_ mainMenu: NSMenu, name: String) {
        let submenu = mainMenu.addItem(withTitle: "File", action: nil, keyEquivalent: "")
        let menu = NSMenu(title: "File")
        mainMenu.setSubmenu(menu, for: submenu)
    }
    
    private func createViewMenu(_ mainMenu: NSMenu, name: String) {
        let submenu = mainMenu.addItem(withTitle: "View", action: nil, keyEquivalent: "")
        let menu = NSMenu(title: "View")
        mainMenu.setSubmenu(menu, for: submenu)
    }

    private func createEditMenu(_ mainMenu: NSMenu, name: String) {
        let submenu = mainMenu.addItem(withTitle: "Edit", action: nil, keyEquivalent: "")
        let menu = NSMenu(title: "Edit")
        mainMenu.setSubmenu(menu, for: submenu)

        menu.addItem(withTitle:"Undo", action:#selector(UndoActionRespondable.undo(_:)), keyEquivalent:"z")
        menu.addItem(withTitle:"Redo", action:#selector(UndoActionRespondable.redo(_:)), keyEquivalent:"Z")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle:"Cut", action:#selector(NSText.cut(_:)), keyEquivalent:"x")
        menu.addItem(withTitle:"Copy", action:#selector(NSText.copy(_:)), keyEquivalent:"c")
        menu.addItem(withTitle:"Paste", action:#selector(NSText.paste(_:)), keyEquivalent:"v")
        menu.addItem(withTitle:"Delete", action:#selector(NSText.delete(_:)), keyEquivalent:"\u{8}") // backspace
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle:"Select All", action:#selector(NSText.selectAll(_:)), keyEquivalent:"a")
    }
    
    private func createMenu() {
        self.menu = NSMenu(title: "MainMenu")
        NSApp.mainMenu = self.menu
        
        createApplicationMenu(self.menu, name: AppDelegate.applicationName)
        //createFileMenu(self.menu, name: AppDelegate.applicationName)
        createEditMenu(self.menu, name: AppDelegate.applicationName)
        //createViewMenu(self.menu, name: AppDelegate.applicationName)

    }
    
    // MARK: - Split view delegate
    
    func splitView(_ splitView: NSSplitView, effectiveRect proposedEffectiveRect: NSRect, forDrawnRect drawnRect: NSRect, ofDividerAt dividerIndex: Int) -> NSRect {
        // Lock dragging
        return NSRect.zero
    }
        
    func splitView(_ splitView: NSSplitView, resizeSubviewsWithOldSize oldSize: NSSize) {
        guard let mySplitView = splitView as? MySplitView else { return }

        if mySplitView.userTag == 1 {
            let firstView = splitView.subviews[0]
            let secondView = splitView.subviews[1]
            let thirdView = splitView.subviews[2]
            
            let viewWidth = (splitView.frame.size.width - 2*splitView.dividerThickness) / 3

            let firstFrame = NSMakeRect(0, 0, viewWidth, splitView.frame.size.width)
            let secondFrame = NSMakeRect(viewWidth+splitView.dividerThickness, 0, viewWidth, splitView.frame.size.width)
            let thirdFrame = NSMakeRect(2*viewWidth+2*splitView.dividerThickness, 0, viewWidth, splitView.frame.size.width)

            firstView.frame = firstFrame
            secondView.frame = secondFrame
            thirdView.frame = thirdFrame
        }
    }

    // MARK: - Create window and views

    private func createContentView() {
        // Split view contains top part and status line
        _splitView1 = MySplitView(frame: self.window.contentView!.bounds)
        _splitView1.isVertical = true
        _splitView1.userTag = 1
        _splitView1.dividerStyle = .thick
        _splitView1.delegate = self
        _splitView1.autoresizingMask = [.width, .height]
        self.window.contentView?.addSubview(_splitView1)

        _fileView = AppFileView(frame: self.window.contentView!.bounds)
        _fileView.autoresizingMask = [.width, .height]
        _splitView1.addArrangedSubview(_fileView)

        _mdvView = AppMdvView(frame: self.window.contentView!.bounds)
        _mdvView.autoresizingMask = [.width, .height]
        _splitView1.addArrangedSubview(_mdvView)

        _editorView = AppEditorView(frame: self.window.contentView!.bounds)
        _editorView.autoresizingMask = [.width, .height]
        _splitView1.addArrangedSubview(_editorView)
    }

    private func createWindow(_ title: String) {
        let contentRect = NSMakeRect(5, 110, 960, 400)
        let styleMask: NSWindow.StyleMask = [NSWindow.StyleMask.titled, NSWindow.StyleMask.closable, NSWindow.StyleMask.miniaturizable, NSWindow.StyleMask.resizable]
        
        self.window = NSWindow(contentRect: contentRect, styleMask:styleMask, backing: NSWindow.BackingStoreType.buffered, defer: true)
        self.window.title = title
        self.window.delegate = self
        self.window.makeKeyAndOrderFront(nil)

        createContentView()
    }

    // MARK: - UI
    
    private func updateUI() {
        if let mdvFilename = _mdvFilename {
            _mdvView.setHeader("\(mdvFilename) (\(_mdvView.dataCount) files)")
        }
        else {
            self._mdvView.setHeader("No mdv file selected")
        }

        if _contentFilename == nil {
            _editorView.setEmptyContent()
        }
        
        self.toolbar.enableItem("save", enable: _editorView.fileChanged)
        self.toolbar.enableItem("add", enable: _mdvFilename != nil ? true : false)
        self.toolbar.enableItem("extract", enable: _contentFilename != nil ? true : false)
    }

    private func createUI() {
        createWindow("QLmdv " + AppDelegate.applicationVersion)
        createMenu()
        createToolbar()

        register(for: .doubleClick) { (action, tag) in
            guard let filename = self._fileView.selectedData else { return }
            
            // Check if its a folder
            let path = self._path + "/" + filename
            if RBFileUtility.isFolder(path) {
                self.addToPath(filename)
            }
        }

        register(for: .click) { (action, tag) in
            if tag == .fileView {
                guard let filename = self._fileView.selectedData else { return }
                
                // Check if its a folder
                let path = self._path + "/" + filename
                if !RBFileUtility.isFolder(path) {
                    self.loadMdv(filename)
                }
                else {
                    self._mdvView.setData([])
                    self._mdvFilename = nil
                    self._contentFilename = nil
                    self.updateUI()
                }
            }

            if tag == .mdvView {
                guard let filename = self._mdvView.selectedData else { return }
                
                // Extract and open
                self.openFile(filename)
            }
        }

        register(for: .fileChanged) { (action, tag) in
            if tag == .editor {
                self.updateUI()
            }
        }
    }
    
    // MARK: - Mdv handling
    
    private func createListFile() {
        guard let mdvFilename = _mdvFilename else { return }

        var str = ""
        for entry in _mdvView.data {
            let filename = entry + "\n"
            str = str + filename
        }

        let lstFilename = _temporaryPath + mdvFilename + ".lst"

        RBFileUtility.saveString(str, path: lstFilename)
    }

    private func moveAllFilesToMdv() {
        guard let mdvFilename = _mdvFilename else { return }

        QltBridge.setTemporaryPath(_temporaryPath)

        createListFile()

        let lstFilename = _temporaryPath + mdvFilename + ".lst"
        let path = _path + "/" + mdvFilename
        QltBridge.file(toMdv: path, listFilename: lstFilename)
    }
    
    private func loadMdv(_ filename: String) {
        let path = _path + "/" + filename
        QltBridge.listMdv(path)
        
        let list = QltBridge.qltGetFiles()
        var files: [String] = []
        
        for entry in list {
            if let filename = entry as? String {
                files.append(filename)
            }
        }

        _mdvView.setData(files)
        _mdvFilename = filename
        _contentFilename = nil
        
        updateUI()
    }
    
    private func createMdv(_ filename: String) {
        let path = _path + "/" + filename + ".MDV"
        RBFileUtility.saveString("", path: path)

        loadDirectory()
    }

    private func openFile(_ name: String) {
        guard let mdvFilename = _mdvFilename else { return }

        QltBridge.setTemporaryPath(_temporaryPath)

        let dirFilename = _temporaryPath + mdvFilename + ".dir"
        RBFileUtility.deleteFile(path: dirFilename)
        QltBridge.setDirectoryFile(dirFilename)
        
        let path = _path + "/" + mdvFilename
        QltBridge.mdv(toFile: path)

        // Now open
        let filepath = _temporaryPath + name
        _editorView.loadFile(filepath, filename: name)
        
        _contentFilename = name
        
        updateUI()
    }
    
    private func addFileToMdv(_ filename: String) {
        var destName = filename.lastPathComponent
        destName = destName.replacingOccurrences(of: ".", with: "_")
        let destPath = _temporaryPath + destName
        
        let sourceUrl = URL(fileURLWithPath: filename)
        let destUrl = URL(fileURLWithPath: destPath)
        RBFileUtility.fileCopy(from: sourceUrl, to: destUrl)
        
        _mdvView.addDataRow(destName)
        
        createListFile()
        
        moveAllFilesToMdv()
    }

    private func saveCurrentFile() {
        guard let contentFilename = self._contentFilename else { return }
        
        let filepath = self._temporaryPath + contentFilename
        self._editorView.saveFile(filepath)
        self.moveAllFilesToMdv()

        self.updateUI()
    }

    // MARK: - Directory handling
    
    private func loadDirectory() {
        let list = RBFileUtility.listFiles(path: _path, excludeHiddenFiles: true)
        var files = [String]()
        
        for filename in list {
            let path = _path + "/" + filename
            if RBFileUtility.isFolder(path) {
                files.append(filename)
            }
            else {
                // ... and .MDV
                let parts = filename.components(separatedBy: ".")
                if parts.count >= 2 {
                    if parts[1].uppercased() == "MDV" {
                        files.append(filename)
                    }
                }
            }
        }
        
        if _path != "/" {
            files.insert("..", at: 0)
        }
        
        _fileView.setData(files)
        _fileView.setHeader(_path)
        
        _editorView.setEmptyContent()
        _mdvView.setData([])
        _mdvFilename = nil
        _contentFilename = nil

        RBDefaultStore.setLastProjectPath(path: _path)

        updateUI()
    }

    private func addToPath(_ name: String) {
        if name == ".." {
            let url = URL(fileURLWithPath: _path, isDirectory: true)
            _path = url.deletingLastPathComponent().path
        }
        else {
            if _path != "/" {
                _path = _path + "/" + name
            }
            else {
                _path = _path + name
            }
        }
        
        loadDirectory()
    }

    private func createSaveFolder() {
        if RBFileUtility.fileExists(path: _temporaryPath) {
            return
        }
        
        RBFileUtility.createFolder(path: _temporaryPath)
    }

    private func loadCurrentPath() {
        if let path = RBDefaultStore.getLastProjectPath() {
            _path = path
        }
        else {
            _path = RBFileUtility.homePath()
            RBDefaultStore.setLastProjectPath(path: _path)
        }
    }

    // MARK: - Application life cycle
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        RBLog.severity = .debug
        
        createUI()
        
        createSaveFolder();
        rbDebug("Files we be saved at \(_temporaryPath)")

        loadCurrentPath();
        loadDirectory();
        _editorView.setEmptyContent()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func applicationWillTerminate(_ aNotification: Notification) { }
    
    static let shared : AppDelegate = {
        let instance = NSApplication.shared.delegate as? AppDelegate
        return instance!
    }()

}

// MARK: - Helpers

class MySplitView : NSSplitView {
    var userTag = 0
}

@objc protocol UndoActionRespondable {
    @objc func undo(_ sender: AnyObject);
    @objc func redo(_ sender: AnyObject);
}
