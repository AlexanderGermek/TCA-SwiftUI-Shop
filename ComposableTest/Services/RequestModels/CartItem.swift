//
//  CartItem.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 21.01.2024.
//


struct CartItem: Equatable, Encodable {
	let product: Product
	let quantity: Int
}

extension CartItem {
	static var sample: [CartItem] {
		[
			.init(product: Product.sample[0], quantity: 3),
			.init(product: Product.sample[1], quantity: 1),
			.init(product: Product.sample[2], quantity: 1)
		]
	}
}
