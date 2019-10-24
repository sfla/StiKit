import UIKit
import StiKitUtilities

public class TextCellViewModel:CellViewModel{
    
    public let text:Observable<String?>
    public let subtitle:Observable<String?>
    
    public init(text:String?, subtitle:String? = nil, leadingSwipeActions:UISwipeActionsConfiguration? = nil, trailingSwipeActions:UISwipeActionsConfiguration? = nil){
        self.text = Observable(text)
        self.subtitle = Observable(subtitle)
        super.init()
        
        self.leadingSwipeActions = leadingSwipeActions
        self.trailingSwipeActions = trailingSwipeActions
    }
}

public class TextCell:TableViewCell{
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    public required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    
    override public func bind(viewModel: ViewModel) {
        if let vm = viewModel as? TextCellViewModel{
            vm.text.observe { [weak self] (text) in
                self?.textLabel?.text = text
            }.disposed(by: boundDisposeBag)
            
            vm.subtitle.observe { [weak self] (subtitle) in
                self?.detailTextLabel?.text = subtitle
            }.disposed(by: boundDisposeBag)
        }
    }
}
