
import Cocoa

class RBTreeView : OSView, NSTableViewDataSource, NSTableViewDelegate {
    private var _scrollView: NSScrollView!
    private var _tableView: NSTableView!
    private var _column: NSTableColumn!
    private var _observerTag: ObserverTag = .none
    private var _data: [String] = []
    
    // MARK: - Property

    var observerTag: ObserverTag {
        set { _observerTag = newValue }
        get { return _observerTag }
    }

    // MARK: - Data
    
    var dataCount: Int {
        return _data.count
    }
    
    var data: [String] {
        return _data
    }

    var selectedData: String? {
        guard _tableView.selectedRow >= 0 else { return nil }
        return _data[_tableView.selectedRow]
    }

    func setHeader(_ title: String) {
        _column.title = title
    }

    func setData(_ data: [String]) {
        _data = data
        _tableView.reloadData()
    }

    func addDataRow(_ row: String) {
        _data.append(row)
        _tableView.reloadData()
    }

    // MARK: - Delegate & Data Source

    func tableViewSelectionDidChange(_ notification: Notification) {
        rbDebug("Row changed: \(_tableView.selectedRow)")
        
        guard _tableView.selectedRow >= 0 else { return }
        
        notify(with: .click, tag: _observerTag)
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return _data.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return _data[row]
    }

    func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        return false
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 20
    }
    
    // MARK: - User actions

    @objc func doubleClickRow() {
        notify(with: .doubleClick, tag: _observerTag)
    }
    
    // MARK: - View life cycle
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        _scrollView.frame = self.bounds
        _tableView.frame = self.bounds
        
        _column.width = self.bounds.size.width-50
    }

    // MARK: - Initialisation
    
    private func initView() {
        self.wantsLayer = true
        self.layer?.backgroundColor = App.Color.viewBackground.cgColor
        
        _scrollView = NSScrollView(frame:NSMakeRect(0, 0, 100, 100))
        _scrollView.hasVerticalScroller = true
        _scrollView.backgroundColor = App.Color.viewBackground

        _tableView = NSTableView(frame: NSRect.make(0, 0, 100, 100))
        _tableView.backgroundColor = App.Color.viewBackground
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.usesAlternatingRowBackgroundColors = true
        _tableView.doubleAction = #selector(doubleClickRow)
        _scrollView.documentView = _tableView
        self.addSubview(_scrollView)
        
        _column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "object"))
        _column.title = "Filename"
        _column.width = 220
        _tableView.addTableColumn(_column)
        
        _tableView.reloadData()
    }
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
}




