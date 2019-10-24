import Foundation

public class Observable<T> {
    public typealias Listener = (T) -> Void

    private var listeners:[UUID: Listener] = [:]

    public var value:T{
        didSet{ //TODO2 print out which thread is being used here, and test entire app, make sure only Main thread is used?
            listeners.values.forEach({$0(value)})
        }
    }
    public init(_ value:T){
        self.value = value
    }

    /** Receive callback when this variable changes value. Pass `ignoreCurrent:true` if you don't want the inital value to immediately trigger th is. */
    public func observe(ignoreCurrent:Bool = false, _ listener: @escaping Listener)->Disposable{
        let identifier = UUID()
        self.listeners[identifier] = listener
        if !ignoreCurrent{
            listener(value)
        }
        return Disposable { self.listeners.removeValue(forKey: identifier) }
    }

    public func updated() {
        listeners.values.forEach({$0(value)})
    }
}
public class Disposable{
    public let dispose: () -> Void
    public init(_ dispose:@escaping ()->Void) { self.dispose = dispose }
    deinit { dispose() }

    /** Assign a DisposeBag to this disposable variable. It is responsible for retaining the observation. Without this, it will immediately be released. */
    @discardableResult
    public func disposed(by bag: DisposeBag) -> DisposeBag {
        bag.append(self)
        return bag
    }
}
public class DisposeBag {
    public init() {}
    private var disposables: [Disposable] = []
    public func append(_ disposable: Disposable) { disposables.append(disposable) }
}
