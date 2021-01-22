
import Foundation

enum RBPathType {
    case document, cache
}

class RBFileUtility {

    // MARK: - User folders

    static func cachePath() -> String {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths.first!.path
    }

    static func documentsPath() -> String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!.path
    }

    static func homePath() -> String {
        let url = FileManager.default.homeDirectoryForCurrentUser
        return url.path
    }

    // MARK: - Get files
    
    class func listFiles(path: String, excludeHiddenFiles: Bool = true) -> [String] {
        do {
            var fileList = try FileManager.default.contentsOfDirectory(atPath: path)
            
            if excludeHiddenFiles {
                fileList = fileList.filter { filename in
                    return filename[0] != "."
                }
            }
            
            return fileList
        }
        catch let error as NSError {
            rbWarning("List file in folder failed: '\(path)' -> \(error.localizedDescription)")
            return []
        }
    }

    // MARK: - Folders

    class func isFolder(_ path: String) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: path, isDirectory:&isDirectory)
        return exists && isDirectory.boolValue
    }

    @discardableResult
    class func createFolder(path: String) -> Bool {
        if FileManager.default.fileExists(atPath: path) {
            return false
        }
        
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
        }
        catch let error as NSError {
            rbWarning("Create directory failed: '\(path)': \(error.localizedDescription)")
            return false;
        }
        
        rbDebug("Create directory at: '\(path)'")
        
        return true
    }

    class func pathOfFileInBundle(filename: String, ext: String) -> String? {
        return Bundle.main.path(forResource: filename, ofType: ext)
    }

    // MARK: - Files

    @discardableResult
    class func deleteFile(path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
            rbDebug("Delete file: \(path)");

            return true
        }
        catch {
            rbWarning("Delete file failed: \(path)");
            return false
        }
    }
    
    @discardableResult
    class func renameFile(oldPath: String, newPath: String) -> Bool {
        do {
            try FileManager.default.moveItem(atPath: oldPath, toPath: newPath)
            rbDebug("Rename file: ('\(oldPath)' to '\(newPath)'")
        }
        catch {
            rbWarning("Error rename file: \(error) ('\(oldPath)' to '\(newPath)'")
            return false
        }
        
        return true
    }

    @discardableResult
    class func fileExists(path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }

    // MARK: - String content
    
    class func loadStringFromBundle(filename: String, ext: String) -> String {
        guard let path = RBFileUtility.pathOfFileInBundle(filename: filename, ext: ext) else { return "" }
        
        let url = URL(fileURLWithPath: path)
        do {
            let str = try String(contentsOf: url)
            rbDebug("Load string file: \(path)");

            return str
        }
        catch {
            rbWarning("Load string file failed: \(path) (\(error.localizedDescription))");
            return ""
        }
    }

    class func loadString(path: String) -> String {
        let url = URL(fileURLWithPath: path)

        do {
            let str = try String(contentsOf: url)
            rbDebug("Load string file: \(path)");

            return str
        }
        catch {
            rbWarning("Load string file failed: \(path) (\(error.localizedDescription))");
            return ""
        }
    }

    @discardableResult
    class func saveString(_ content: String, path: String) -> Bool {
        let url = URL(fileURLWithPath: path)

        do {
            try content.write(to: url, atomically: true, encoding: .utf8)
            rbDebug("Save string file: \(path)");

            return true
        }
        catch {
            rbWarning("Save string file failed: \(path) (\(error.localizedDescription))");
            return false
        }
    }

    // MARK: - Cache methods (refactor later maybe)

    class func loadImageFromCache(filename: String, ext: String) -> OSImage? {
        let path = "\(RBFileUtility.cachePath())/\(filename).\(ext)"
        let url = URL(fileURLWithPath: path)

        if let image = OSImage.load(url: url) {
            rbDebug("Load image file: \(filename)");
            return image
        }

        rbWarning("Load image file failed: \(url)");
        return nil
    }
    
    @discardableResult
    class func saveDataToCache(_ content: Data, filename: String, ext: String) -> Bool {
        let path = "\(RBFileUtility.cachePath())/\(filename).\(ext)"
        let url = URL(fileURLWithPath: path)

        do {
            try content.write(to: url)
            rbDebug("Save data file: \(url)");

            return true
        }
        catch {
            rbWarning("Save data file failed: \(url) (\(error.localizedDescription))");
            return false
        }
    }
    
    @discardableResult
    class func saveStringToCache(_ content: String, filename: String, ext: String) -> Bool {
        let path = "\(RBFileUtility.cachePath())/\(filename).\(ext)"
        return saveString(content, path: path)
    }

    // MARK: - Older methods (refactor later)
    
    @discardableResult
    class func fileCopy(from: URL, to: URL) -> Bool {
        do {
            try FileManager.default.copyItem(at: from, to: to)
            rbDebug("File copied from \(from.path) to \(to.path)");

            return true
        }
        catch {
            rbWarning("File NOT copied from \(from.path) to \(to.path)");
            return false
        }
    }

}
