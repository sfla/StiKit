import Foundation

public class Observable<T> {
    public typealias Listener = (T) -> Void

    private var listeners:[UUID: Listener] = [:]
    private var onlyNextListeners:[UUID: Listener] = [:]
    
    public var value:T{
        didSet{ //TODO2 print out which thread is being used here, and test entire app, make sure only Main thread is used?
            listeners.values.forEach({$0(value)})
            onlyNextListeners.values.forEach({$0(value)})
            onlyNextListeners.removeAll()
        }
    }
    public init(_ value:T){
        self.value = value
    }
    public func observe(withoutInitialValue:Bool = false, listener: @escaping Listener)->Disposable{
        let identifier = UUID()
        self.listeners[identifier] = listener
        if !withoutInitialValue{
            listener(value)
        }
        return Disposable { self.listeners.removeValue(forKey: identifier) }
    }
    public func observeOnlyNext(listener: @escaping Listener)->Disposable{
        let identifier = UUID()
        self.onlyNextListeners[identifier] = listener
        return Disposable { self.onlyNextListeners.removeValue(forKey: identifier) }
    }
}

public class Disposable{
    public let dispose: () -> Void
    public init(_ dispose:@escaping ()->Void) { self.dispose = dispose }
    deinit { dispose() }

    /// Assign a DisposeBag to this disposable variable. It is responsible for retaining the observation. Without this, it will immediately be released.
    @discardableResult
    public func disposed(by bag: DisposeBag) -> DisposeBag {
        bag.append(self)
        return bag
    }
}

public class DisposeBag {
    public init(){}
    private var disposables: [Disposable] = []
    public func append(_ disposable: Disposable) { disposables.append(disposable) }
}
