import Foundation
import StiKitUtilities

open class ViewModel{
    public init(){}
}

public protocol BindableView{
    func bind(viewModel:ViewModel)
    var boundDisposeBag:DisposeBag! { get set }
}
