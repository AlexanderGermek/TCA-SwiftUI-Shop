//
//  Common.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 21.01.2024.
//

import Foundation

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
