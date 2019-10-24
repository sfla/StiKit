import UIKit
import StiKitUtilities

public class CellViewModel:ViewModel{
    public static var reuseIdentifier:String {get{ return "\(String(describing: self).replacingOccurrences(of: "ViewModel", with: ""))Identifier"}}
    public var reuseIdentifier:String { get { return type(of: self).reuseIdentifier } }
    
    public var leadingSwipeActions:  UISwipeActionsConfiguration? = nil
    public var trailingSwipeActions: UISwipeActionsConfiguration? = nil
}



public class TableViewCell:UITableViewCell, BindableView{
    public var boundDisposeBag: DisposeBag!
    
    public func bind(viewModel: ViewModel) {
        fatalError("Override bind:ViewModel in \(type(of: self))")
    }
}
