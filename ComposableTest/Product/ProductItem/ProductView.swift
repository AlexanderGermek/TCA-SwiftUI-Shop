//
//  ProductView.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 19.10.2023.
//

import ComposableArchitecture
import SwiftUI

struct ProductCellView: View {
	let store: StoreOf<ProductDomain>
	
	var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			
			VStack {
				AsyncImage(
					url: URL(string: viewStore.product.imageString)
				) { image in
					image
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(height: 300)
				} placeholder: {
					ProgressView()
						.frame(height: 300)
				}
				
				VStack(alignment: .leading) {
					Text(viewStore.product.title)
						.font(.custom("AmericanTypewriter", size: 25))
						.fontWeight(.bold)
					
					Text("\(viewStore.product.description.description)")
						.font(.custom("AmericanTypewriter", size: 18))
					
					HStack {
						Text("$\(viewStore.product.price.description)")
							.font(.custom("AmericanTypewriter", size: 25))
							.fontWeight(.bold)
						
						Spacer()
						
						AddToCartButtonView(
							store: self.store.scope(
								state: \.addToCartState,
								action: ProductDomain.Action.addToCart
							)
						)
					}
				}
				.font(.custom("AmericanTypewriter", size: 20))
			}
			.padding(0)
		}
	}
}

struct ProductCell_Previews: PreviewProvider {
	static var previews: some View {
		ProductCellView(
			store: .init(initialState: ProductDomain.State(
				id: UUID(),
				product: Product.sample[0])) {
					return ProductDomain()
				}
		)
		.previewLayout(.fixed(width: 300, height: 300))
	}
}
