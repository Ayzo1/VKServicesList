import Foundation
import UIKit

final class ServicesPresenter: ServicesPresenterProtocol {
		
	// MARK: - Private properties
	
	private var networkService: NetworkServiceProtocol?
	private var vkServices: [VKService]?
	
	// MARK: - Properties
	
	weak var view: ServicesViewProtocol?
	
	// MARK: - Init
	
	init(view: ServicesViewProtocol) {
		self.view = view
		guard let service: NetworkServiceProtocol = ServiceLocator.shared.resolve() else {
			return
		}
		networkService = service
		
		downloadServices()
	}
	
	// MARK: - StocksPresenterProtocol
    
    func didTap(index: Int) {
        guard let service = vkServices?[index] else {
            return
        }
        guard let url = URL(string: service.link) else {
            return
        }
        let appUrl = URL(string: "\(url.host!.split(separator: ".")[0])://")!
        
        if UIApplication.shared.canOpenURL(appUrl) {
            UIApplication.shared.open(appUrl)
        } else {
            UIApplication.shared.open(url)
        }
    }
	
	func getService(for index: Int) -> VKService? {
		return vkServices?[index]
	}
	
	func getServicesCount() -> Int {
		guard let services = vkServices else {
			return 0
		}
		return services.count
	}
	
	// MARK: - Private methods
	
	private func downloadServices() {
		
		guard let url = URL(string: Constants.stringURL) else {
			view?.failure(error: NetworkError.badURL)
			return
		}
		
		networkService?.fetchFromUrl(url: url) { [weak self] result in
			switch result {
			case .failure(let error):
				self?.view?.failure(error: error)
			case .success(let data):
				do {
					let decoder = JSONDecoder()
					let parsedData = try decoder.decode(RequestResult.self, from: data)
					self?.vkServices = parsedData.body.services
					self?.view?.success()
				} catch {
					self?.view?.failure(error: NetworkError.couldNotParse)
				}
			}
		}
	}
}
