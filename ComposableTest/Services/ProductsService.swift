//
//  ProductsService.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 21.01.2024.
//

import Foundation
import ComposableArchitecture

enum NetworkError: Error {
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

/// Сервис для работы с API продуктов
struct ProductService {

	var fetchProducts: @Sendable () async throws -> [Product]
	var sendOrder: @Sendable ([CartItem]) async throws -> String

	enum Constants {
		static let productsURL = "https://fakestoreapi.com/products"
		static let cartsURL = "https://fakestoreapi.com/carts"
	}
}

// MARK: - DependencyKey
extension ProductService: DependencyKey {

	static var liveValue: ProductService = Self(

		// Получить доступные товары
		fetchProducts: {

			guard let url = URL(string: Constants.productsURL) else {
				throw NetworkError.invalidURL
			}

			guard let (data, _) = try? await URLSession.shared.data(from: url) else {
				throw NetworkError.networkError
			}

			guard let products = try? JSONDecoder().decode([Product].self, from: data) else {
				throw NetworkError.decodeError
			}

			return products
		},

		// Оформить заказ
		sendOrder: { cartItems in

			guard let payload = try? JSONEncoder().encode(cartItems) else {
				throw NetworkError.encodeError
			}
			
			guard let url = URL(string: Constants.cartsURL) else {
				throw NetworkError.invalidURL
			}

			var urlRequest = URLRequest(url: url)

			urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
			urlRequest.httpMethod = HTTPMethod.post.rawValue

			guard let (_, response) = try? await URLSession.shared.upload(for: urlRequest, from: payload) else {
				throw NetworkError.uploadError
			}

			guard let httpResponse = response as? HTTPURLResponse else {
				throw NetworkError.httpResponse
			}

			return "Status: \(httpResponse.statusCode)"
		})
}
