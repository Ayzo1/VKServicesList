//
//  AppDelegate.swift
//  VKServicesList
//
//  Created by ayaz on 14.07.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		window = UIWindow(frame: UIScreen.main.bounds)
		let navigationController = CustomNavigationController(rootViewController: ServicesViewController())
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
		
		registerDependencies()
		return true
	}
	
	private func registerDependencies() {
		let networkService: NetworkServiceProtocol = NetworkService()
		ServiceLocator.shared.register(service: networkService)
	}
}

