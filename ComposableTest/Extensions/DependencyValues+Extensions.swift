//
//  DependencyValues+Extensions.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 21.01.2024.
//

import ComposableArchitecture

// MARK: - DependencyValues
extension DependencyValues {

	var productService: ProductService {
		get { self[ProductService.self] }
		set { self[ProductService.self] = newValue }
	}

	var userProfileService: UserProfileService {
		get { self[UserProfileService.self] }
		set { self[UserProfileService.self] = newValue }
	}
}
