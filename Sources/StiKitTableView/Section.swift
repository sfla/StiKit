import Foundation

public class Section{
    
    public var headerViewModel:HeaderViewModel
    public var viewModels:[CellViewModel]
    public var footerViewModel:HeaderViewModel
    public var selectedAction:((Section, Int)->())?
    
    public init(headerViewModel:HeaderViewModel = SpaceHeader(20), viewModels:[CellViewModel], footerViewModel:HeaderViewModel = SpaceHeader(0), selectedAction:((Section, Int)->())? = nil){
        self.headerViewModel = headerViewModel
        self.viewModels = viewModels
        self.footerViewModel = footerViewModel
        self.selectedAction = selectedAction
    }
}
