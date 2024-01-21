//
//  ProductsService.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 21.01.2024.
//

import Foundation
import ComposableArchitecture

/// Сервис для работы с API продуктов
struct ProductService {

	enum Constants {
		static let productsURL = "https://fakestoreapi.com/products"
		static let cartsURL = "https://fakestoreapi.com/carts"
	}

	var fetchProducts: @Sendable () async throws -> [Product]
	var sendOrder: @Sendable ([CartItem]) async throws -> String
}

// MARK: - Enums extensions
extension ProductService {

	enum ProductServiceError: Error {
		case networkError
		case invalidURL
		case decodeError
		case encodeError
		case uploadError
		case httpResponse
	}

	enum HTTPMethod: String {
		case get = "GET"
		case post = "POST"
	}
}

// MARK: - DependencyValues
extension DependencyValues {
	var productService: ProductService {
		get { self[ProductService.self] }
		set { self[ProductService.self] = newValue }
	}
}

// MARK: - DependencyKey
extension ProductService: DependencyKey {

	static var liveValue: ProductService = Self(

		// Получить доступные товары
		fetchProducts: {

			guard let url = URL(string: Constants.productsURL) else {
				throw ProductServiceError.invalidURL
			}

			guard let (data, _) = try? await URLSession.shared.data(from: url) else {
				throw ProductServiceError.networkError
			}

			guard let products = try? JSONDecoder().decode([Product].self, from: data) else {
				throw ProductServiceError.decodeError
			}

			return products
		},

		// Оформить заказ
		sendOrder: { cartItems in

			guard let payload = try? JSONEncoder().encode(cartItems) else {
				throw ProductServiceError.encodeError
			}

			guard let url = URL(string: Constants.cartsURL) else {
				throw ProductServiceError.invalidURL
			}

			var urlRequest = URLRequest(url: url)

			urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
			urlRequest.httpMethod = HTTPMethod.post.rawValue

			guard let (_, response) = try? await URLSession.shared.upload(for: urlRequest, from: payload) else {
				throw ProductServiceError.uploadError
			}

			guard let httpResponse = response as? HTTPURLResponse else {
				throw ProductServiceError.httpResponse
			}

			return "Status: \(httpResponse.statusCode)"
		})
}

