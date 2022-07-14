import Foundation

protocol ServicesPresenterProtocol {
	
	var view: ServicesViewProtocol? { get }
	
	func getService(for index: Int) -> VKService?
	func getServicesCount() -> Int
}
