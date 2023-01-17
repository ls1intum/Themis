
import Foundation

// This class allows to safely publish data that is required for the scroll-to-feedback feature during view updates
public class ScrollUtils {
    public var range: NSRange?
    public var offsets: [NSRange: CGFloat]
    
    public init(range: NSRange? = nil, offsets: [NSRange: CGFloat]) {
        self.range = range
        self.offsets = offsets
    }
}
