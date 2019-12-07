import Foundation


public protocol ObservableDelegate: class {
    func observableDidSet<T>(_ observable: Observable<T>)
    func observableDidAddListener<T>(_ observable: Observable<T>)
    func observableDidRemoveListener<T>(_ observable: Observable<T>)
}
extension ObservableDelegate {
    func observableDidSet<T>(_ observable: Observable<T>)  { }
    func observableDidAddListener<T>(_ observable: Observable<T>)  { }
    func observableDidRemoveListener<T>(_ observable: Observable<T>)  { }
}


public class Observable<T> {
    public typealias Listener = (T) -> Void

    private var listeners:[UUID: Listener] = [:]
    public weak var delegate: ObservableDelegate? = nil
    public var listenerCount: Int { return listeners.compactMapValues({ $0 }).count }

    public var value:T{
        didSet{ //TODO2 print out which thread is being used here, and test entire app, make sure only Main thread is used?
            delegate?.observableDidSet(self)
            listeners.values.forEach({$0(value)})
        }
    }
    public init(_ value:T){
        self.value = value
    }

    /// Receive callback when this variable changes value. Pass `ignoreCurrent:true` if you don't want the inital value immediately trigger this.
    public func observe(ignoreCurrent:Bool = false, _ listener: @escaping Listener)->Disposable{
        let identifier = UUID()
        if self.listeners[identifier] == nil {
            self.listeners[identifier] = listener
            self.delegate?.observableDidAddListener(self)
        }
        if !ignoreCurrent{
            listener(value)
        }
        return Disposable {
            if self.listeners.removeValue(forKey: identifier) != nil {
                self.delegate?.observableDidRemoveListener(self)
            }
        }
    }

    public func updated() {
        listeners.values.forEach({$0(value)})
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
