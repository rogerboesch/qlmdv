
import Foundation

typealias RBToolbarCallback = (Int, Any) -> ()

class RBToolbar : RBOSView, OSTextFieldDelegate {
    private var _items = Dictionary<String, OSView>()
    private var _callbacks = Array<RBToolbarCallback?>()
    private var _childs: [OSView] = []
    private var _x: OSFloat = 10;
    private var _y: OSFloat = 0;
    private var _height: OSFloat = 20;
    private var _space: OSFloat = 10;
    private var _dockingTop = true
    
    // -------------------------------------------------------------------------
    // MARK: - Item actions
    
    @objc func buttonPressed(_ button: OSButton) {
        let tag = button.tag - 1
        let callback = _callbacks[tag]
        
        if callback == nil {
            return
        }

        callback?(0, button)
    }

    // -------------------------------------------------------------------------
    // MARK: - Item adding
    
    func setItemText(_ text: String, name: String) {
        guard let view = _items[name] else { return }
        
        if let label = view as? OSLabel {
            label.text = text
        }
        
        if let button = view as? OSButton {
#if os(iOS)
            button.setTitle(text)
#else
            button.title = text
#endif
        }
    }
    
    func setItemColor(_ color: OSColor, name: String) {
        guard let view = _items[name] else { return }
        guard let label = view as? OSLabel else { return }

        label.textColor = color
    }

    func enableItem(_ flag: Bool, name: String) {
        guard let view = _items[name] else { return }

        if let button = view as? OSButton {
            button.isEnabled = flag
        }
    }

    func textOfItem(name: String) -> String? {
        guard let view = _items[name] else { return nil }

        if let field = view as? OSField {
            return field.getText()
        }

        return "";
    }

    // -------------------------------------------------------------------------
    // MARK: - Item adding

    func addItem(name: String, title: String, icon: OSImage? = nil, width: OSFloat = 50, _ callback: RBToolbarCallback? = nil) {
        var name = name
        let item = _items[name]
        if item != nil {
            name = name + "\(_items.count)"
        }
        
        let button = OSButton(frame: OSRect.make(_x, _y, width, _height))
        button.setTitle(title)
        button.setImage(icon)
        button.setTarget(self, action:  #selector(buttonPressed(_:)))
        button.setDefaultStyle()
        
#if os(iOS)
        button.titleLabel?.font = OSFont.systemFont(ofSize: 14)
        button.setTitle(" \(title)")
#endif
        
        self.addSubview(button)

        if icon != nil && title.count > 0 {
            button.alignImageLeft()
        }
        
        // Add item
        _childs.append(button)
        _items[name] = button
        
        let tag = _callbacks.count + 1
        button.tag = tag
        _callbacks.append(callback)
        
        _x += width + _space
    }
    
    func addSpace(_ width: OSFloat = 20) {
        var name = "space\(width)"
        let item = _items[name]
        
        if item != nil {
            name = name + "\(_items.count)"
        }
        
        let button = OSView(frame: OSRect.make(_x, _y, width, _height))
        self.addSubview(button)

        // Add item
        _childs.append(button)
        _items[name] = button

        _x += width + _space
    }
    
    func addLabel(name: String, text: String, width: OSFloat = 200, color: OSColor = .white) {
        var name = name

        let item = _items[name]
        
        if item != nil {
            name = name + "\(_items.count)"
        }
        
        let label = OSLabel(frame: OSRect.make(_x, _y, width, _height))
        label.setLeft()
        label.textColor = color
        label.text = text
        self.addSubview(label)

        // Add item
        _childs.append(label)
        _items[name] = label
        
        _x += width + _space
    }
    
    func addField(name: String, text: String, width: OSFloat = 200, color: OSColor = .black, _ callback: RBToolbarCallback? = nil) {
        var name = name

        let item = _items[name]
        
        if item != nil {
            name = name + "\(_items.count)"
        }
        
        let field = OSField(frame: OSRect.make(_x, _y+2, width, _height-6))
        field.setDefaultStyle()
        field.delegate = self
        field.textColor = color
        field.setText(text)
        self.addSubview(field)

        // Add item
        _childs.append(field)
        _items[name] = field

        let tag = _callbacks.count + 1
        field.tag = tag
        _callbacks.append(callback)
        
        _x += width + _space
    }

    func addCustomView(name: String, view: RBOSView) {
        var name = name

        let item = _items[name]
        
        if item != nil {
            name = name + "\(_items.count)"
        }

        view.frame = OSRect.make(_x, _y, view.frame.size.width, _height)
        self.addSubview(view)

        // Add item
        _childs.append(view)
        _items[name] = view
        
        _x += view.frame.size.width + _space
    }

    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    override init(frame: OSRect) {
        super.init(frame: frame)
        
        _height = App.Toolbar.height-2*2
        _y = (App.Toolbar.height-_height) / 2
        self.backgroundColor = App.Toolbar.color
    }
    
    init(parent: OSView, dockingTop: Bool = true) {
        _dockingTop = dockingTop

        var rect = OSRect.make(0, 0, parent.frame.size.width, App.Toolbar.height)
        if !_dockingTop {
            rect = OSRect.make(0, parent.frame.size.height-App.Toolbar.height, parent.frame.size.width, App.Toolbar.height)
        }
        
        super.init(frame: rect)
        
        _height = App.Toolbar.height-2*2
        _y = (App.Toolbar.height-_height) / 2
        self.backgroundColor = App.Toolbar.color
        
        parent.addSubview(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // -------------------------------------------------------------------------
    
}



