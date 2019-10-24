import UIKit
import StiKitUtilities

public class HeaderViewModel:CellViewModel{}

//Special class, does not dequeue or instantiate a UIView. Custom logic in delegate.
public class SpaceHeader:HeaderViewModel{
    public let space:CGFloat
    public init(_ space:CGFloat){
        self.space = space
        super.init()
    }
}

public class TableViewHeaderFooterView: UITableViewHeaderFooterView, BindableView {
    
    public var boundDisposeBag: DisposeBag!
    
    public func bind(viewModel: ViewModel) {
        fatalError("Override bind:ViewModel in \(type(of: self))")
    }
    
}
