import UIKit
import StiKitExtensions
import StiKitUtilities

open class TableView: UITableView {
    
    fileprivate var registeredIdentifiers:Set<String> = []
    fileprivate var registeredHeaderFooterIdentifiers:Set<String> = []
    
    open private(set) var sections:[Section] = []
    
    private let log = Logger("TableView")
    
    open var allowSimultaneousGestures:Bool = false
    open var hiddenSeparators:Bool = false
    open var preferredSeparatorColor:UIColor = .gray { didSet { self.separatorColor = preferredSeparatorColor } }
    open var preferredSeparatorStyle:UITableViewCell.SeparatorStyle = .singleLine
    
    
    public init(){
        super.init(frame: .zero, style: .grouped)
        commonInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit(){
        
        if #available(iOS 13.0, *) {
            self.backgroundColor = .systemBackground
            preferredSeparatorColor = .separator
        } else {
            self.backgroundColor = .white
            preferredSeparatorColor = .gray
        }
        
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 44
        assert(self.style == .grouped)
        self.delegate = self
        self.dataSource = self
    }
    
    ///Replace the entire dataset
    public func updateData(sections:[Section]){
        self.sections = sections
        registerCellsIfNeeded()
        
        hiddenSeparators ? hideSeparators() : showSeparators()
        
        self.reloadData()
    }
    
    private func hideSeparators(){
        self.separatorColor = .clear
        self.separatorStyle = .none
    }
    private func showSeparators(){
        self.separatorColor = preferredSeparatorColor
        self.separatorStyle = preferredSeparatorStyle
    }
    
    ///Automatically register any new cells and headers/footers, if needed.
    private func registerCellsIfNeeded(){
        var identifiers:[String:AnyClass] = [:]
        var headerFooterIdentifiers:[String:AnyClass] = [:]
        sections.forEach { (section) in
            section.viewModels.forEach({ (cellViewModel) in
                if !identifiers.keys.contains(cellViewModel.reuseIdentifier){
                    identifiers[cellViewModel.reuseIdentifier] = type(of: cellViewModel)
                }
            })
            if !(section.headerViewModel is SpaceHeader) && !headerFooterIdentifiers.keys.contains(section.headerViewModel.reuseIdentifier){
                headerFooterIdentifiers[section.headerViewModel.reuseIdentifier] = type(of: section.headerViewModel)
            }
            if !(section.footerViewModel is SpaceHeader) && !headerFooterIdentifiers.keys.contains(section.footerViewModel.reuseIdentifier){
                headerFooterIdentifiers[section.footerViewModel.reuseIdentifier] = type(of: section.footerViewModel)
            }
            
        }
        let cellsToRegister = identifiers.filter { (tuple) -> Bool in
            return !self.registeredIdentifiers.contains(tuple.key)
        }
        cellsToRegister.forEach { (tuple) in
            if tuple.key == "TextCellIdentifier"{
                self.register(TextCell.self, forCellReuseIdentifier: tuple.key)
            }else{
                let nib = UINib(nibName: tuple.key.replacingOccurrences(of: "Identifier", with: ""), bundle: Bundle(for: tuple.value))
                self.register(nib, forCellReuseIdentifier: tuple.key)
            }
            self.registeredIdentifiers.insert(tuple.key)
        }
        
        let headerFootersToRegister = headerFooterIdentifiers.filter { (tuple) -> Bool in
            return !self.registeredHeaderFooterIdentifiers.contains(tuple.key)
        }
        headerFootersToRegister.forEach { (tuple) in
            let nib = UINib(nibName: tuple.key.replacingOccurrences(of: "Identifier", with: ""), bundle: Bundle(for: tuple.value))
            self.register(nib, forHeaderFooterViewReuseIdentifier: tuple.key)
            self.registeredHeaderFooterIdentifiers.insert(tuple.key)
        }
    }
    public func registerCell(cell:CellViewModel.Type){
        if self.registeredIdentifiers.contains(cell.reuseIdentifier) { return }
        let nib = UINib(nibName: cell.reuseIdentifier.replacingOccurrences(of: "Identifier", with: ""), bundle: Bundle(for: cell))
        self.register(nib, forCellReuseIdentifier: cell.reuseIdentifier)
        self.registeredIdentifiers.insert(cell.reuseIdentifier)
    }
}

extension TableView:UITableViewDataSource{
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].viewModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = sections[indexPath.section].viewModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: vm.reuseIdentifier, for: indexPath)
        if let c = cell as? TableViewCell{
            c.boundDisposeBag = DisposeBag()
            UIView.performWithoutAnimation {
                c.bind(viewModel: vm)
            }
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vm = sections[section].headerViewModel
        if vm is SpaceHeader { return nil }
        let header = self.dequeueReusableHeaderFooterView(withIdentifier: vm.reuseIdentifier)
        if let h = header as? TableViewHeaderFooterView{
            h.boundDisposeBag = DisposeBag()
            UIView.performWithoutAnimation {
                h.bind(viewModel: vm)
            }
        } else { log.warning("Could not dequeue headerView") }
        return header
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vm = sections[section].footerViewModel
        if vm is SpaceHeader { return nil }
        let footer = self.dequeueReusableHeaderFooterView(withIdentifier: vm.reuseIdentifier)
        if let f = footer as? TableViewHeaderFooterView{
            f.boundDisposeBag = DisposeBag()
            UIView.performWithoutAnimation {
                f.bind(viewModel: vm)
            }
        } else { log.warning("Could not dequeue footerView") }
        return footer
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (sections[section].headerViewModel as? SpaceHeader)?.space ?? UITableView.automaticDimension
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (sections[section].footerViewModel as? SpaceHeader)?.space ?? UITableView.automaticDimension
    }
}

extension TableView:UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].selectedAction?(sections[indexPath.section], indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? TableViewCell)?.boundDisposeBag = DisposeBag() //Remove any potential observations when cell is unloaded.
    }
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        (view as? TableViewHeaderFooterView)?.boundDisposeBag = DisposeBag()
    }
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        (view as? TableViewHeaderFooterView)?.boundDisposeBag = DisposeBag()
    }
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let vm = sections[indexPath.section].viewModels[indexPath.row]
        return vm.leadingSwipeActions != nil || vm.trailingSwipeActions != nil
    }
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return sections[indexPath.section].viewModels[indexPath.row].leadingSwipeActions
    }
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return sections[indexPath.section].viewModels[indexPath.row].trailingSwipeActions
    }
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return sections[indexPath.section].viewModels[indexPath.row].trailingSwipeActions == nil ? .none : .delete
    }
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        // If trailing swipe actions are implemented - one of them must be for deletion. If not, this needs rework.
        return sections[indexPath.section].viewModels[indexPath.row].trailingSwipeActions != nil
    }
    
}

extension TableView:UIGestureRecognizerDelegate{
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //Specifically for all three buttons in FromAndToView (from/to/time-settings).
        return allowSimultaneousGestures
    }
}

public class SwipeToDeleteAction:UISwipeActionsConfiguration{
    
    public override var actions: [UIContextualAction] { get {
        let action = UIContextualAction(style: .destructive, title: title) { [weak self] (action, view, callback) in
            self?.didDelete()
            callback(true)
        }
        //action.backgroundColor = ...
        //action.image = ...
        
        return [action]
        }}
    
    private var title:String
    private var didDelete:(()->())
    
    public init(title:String, didDelete:@escaping (()->())){
        self.title = title
        self.didDelete = didDelete
        super.init()
    }
}
