import Foundation

protocol NetworkServiceProtocol {
	
	func fetchFromUrl(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}
