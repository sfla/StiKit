import Foundation
import StiKitUtilities

open class ViewModel{}

public protocol BindableView{
    func bind(viewModel:ViewModel)
    var boundDisposeBag:DisposeBag! { get set }
}
