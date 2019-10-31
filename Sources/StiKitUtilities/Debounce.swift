import Foundation
public class Debounce{
    public var callback:(()->())
    public var delay:TimeInterval
    public weak var timer:Timer?
    
    public init(delay:TimeInterval, callback: @escaping (()->())){
        self.callback = callback
        self.delay = delay
    }
    public func call(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(fire), userInfo: nil, repeats: false)
    }
    @objc private func fire(){
        callback()
    }
}
