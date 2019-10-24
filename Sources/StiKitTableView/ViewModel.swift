import Foundation
import StiKitUtilities

public class ViewModel{}

public protocol BindableView{
    func bind(viewModel:ViewModel)
    var boundDisposeBag:DisposeBag! { get set }
}
