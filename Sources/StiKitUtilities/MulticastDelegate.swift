import Foundation


public class MulticastState
{
    public var cancel: Bool = false
}


public class MulticastDelegate <P>
{
    private class WeakWrapper
    {
        weak var value: AnyObject?

        init(value: AnyObject) {
            self.value = value
        }
    }

    private var _weakDelegates = [WeakWrapper]()

    public var count: Int
    {
        // Use the opportunity to remove all dangling weak pointers
        _weakDelegates.removeAll(where: { $0.value == nil })
        return _weakDelegates.count
    }

    @discardableResult
    func add(_ delegate: P) -> Bool {
        if _weakDelegates.first(where: { $0.value === (delegate as AnyObject) }) != nil {
            return false  // not added
        }
        _weakDelegates.append(WeakWrapper(value: delegate as AnyObject))
        return true  // was added
    }

    func remove(_ delegate: P)
    {
        // Also remove all dangling weak pointers
        _weakDelegates.removeAll(where: { $0.value == nil || $0.value === (delegate as AnyObject) })
    }

    func invoke(invocation: (P) -> ())
    {
        for (index, delegate) in _weakDelegates.enumerated() {
            if let delegate = delegate.value {
                invocation(delegate as! P)
            } else {
                _weakDelegates.remove(at: index)
            }
        }
    }

    func invoke(state: MulticastState, invocation: (P) -> ())
    {
        for (index, delegate) in _weakDelegates.enumerated() {
            if state.cancel { break }
            if let delegate = delegate.value {
                invocation(delegate as! P)
            } else {
                _weakDelegates.remove(at: index)
            }
        }
    }

}

extension MulticastDelegate: Sequence
{
    public func makeIterator() -> Array<P>.Iterator
    {
        return _weakDelegates.filter { $0.value != nil }.map { $0 as! P }.makeIterator()
    }
}


public func += <P> (left: MulticastDelegate<P>, right: P) { left.add(right) }
public func -= <P> (left: MulticastDelegate<P>, right: P) { left.remove(right) }
