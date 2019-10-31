import UIKit
import StiKitUtilities

open class TextCellViewModel:CellViewModel{
    
    public let text:Observable<String?>
    public let subtitle:Observable<String?>
    public let backgroundColor:Observable<UIColor>
    
    public init(text:String?, subtitle:String? = nil, leadingSwipeActions:UISwipeActionsConfiguration? = nil, trailingSwipeActions:UISwipeActionsConfiguration? = nil){
        self.text = Observable(text)
        self.subtitle = Observable(subtitle)
        self.backgroundColor = Observable(.white)
        super.init()
        
        self.leadingSwipeActions = leadingSwipeActions
        self.trailingSwipeActions = trailingSwipeActions
    }
}

open class TextCell:TableViewCell{
    
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
            
            vm.backgroundColor.observe { [weak self](backgroundColor) in
                self?.backgroundColor = backgroundColor
            }.disposed(by: boundDisposeBag)
        }
    }
}
