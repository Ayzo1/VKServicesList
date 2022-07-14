import Foundation

protocol ServicesViewProtocol: AnyObject {
	
	func success()
	func failure(error: Error)
}
