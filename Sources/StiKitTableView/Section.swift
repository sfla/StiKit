import Foundation

open class Section{
    
    open var headerViewModel:HeaderViewModel
    open var viewModels:[CellViewModel]
    open var footerViewModel:HeaderViewModel
    open var selectedAction:((Section, Int)->())?
    
    public init(headerViewModel:HeaderViewModel = SpaceHeader(20), viewModels:[CellViewModel], footerViewModel:HeaderViewModel = SpaceHeader(0), selectedAction:((Section, Int)->())? = nil){
        self.headerViewModel = headerViewModel
        self.viewModels = viewModels
        self.footerViewModel = footerViewModel
        self.selectedAction = selectedAction
    }
}
