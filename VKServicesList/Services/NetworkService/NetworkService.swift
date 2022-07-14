import Foundation

final class NetworkService: NetworkServiceProtocol {
	
	// MARK: - Properties
	
	private let configuration: URLSessionConfiguration = .default
	private lazy var urlSession: URLSession = .init(configuration: configuration)
	
	// MARK: - Init

	init() {
			
	}
	
	// MARK: - NetworkingServiceProtocol
		
	public func fetchFromUrl(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
		let request: URLRequest = .init(url: url)
		let dataTask = urlSession.dataTask(with: request) {data, response, error in
			guard (response as? HTTPURLResponse)?.statusCode == 200,
				let data = data,
				error == nil
			else {
				completion(.failure(NetworkError.networkError))
				return
			}
			completion(.success(data))
		}
		dataTask.resume()
	}
}
