import UIKit
import StiKitUtilities

open class CellViewModel:ViewModel{
    public static var reuseIdentifier:String {get{ return "\(String(describing: self).replacingOccurrences(of: "ViewModel", with: ""))Identifier"}}
    public var reuseIdentifier:String { get { return type(of: self).reuseIdentifier } }
    
    open var leadingSwipeActions:  UISwipeActionsConfiguration? = nil
    open var trailingSwipeActions: UISwipeActionsConfiguration? = nil
}



open class TableViewCell:UITableViewCell, BindableView{
    public var boundDisposeBag: DisposeBag!
    
    open func bind(viewModel: ViewModel) {
        fatalError("Override bind:ViewModel in \(type(of: self))")
    }
}
