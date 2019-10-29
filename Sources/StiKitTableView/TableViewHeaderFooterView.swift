import UIKit
import StiKitUtilities

open class HeaderViewModel:CellViewModel{}

//Special class, does not dequeue or instantiate a UIView. Custom logic in delegate.
open class SpaceHeader:HeaderViewModel{
    public let space:CGFloat
    public init(_ space:CGFloat){
        self.space = space
        super.init()
    }
}

open class TableViewHeaderFooterView: UITableViewHeaderFooterView, BindableView {
    
    public var boundDisposeBag: DisposeBag!
    
    public func bind(viewModel: ViewModel) {
        fatalError("Override bind:ViewModel in \(type(of: self))")
    }
    
}
