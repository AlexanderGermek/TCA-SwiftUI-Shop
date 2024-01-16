//
//  ProductView.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 19.10.2023.
//

import ComposableArchitecture
import SwiftUI

struct ProductCellView: View {
  let store: StoreOf<ProductFeature>

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

          HStack {
            Text("$\(viewStore.product.price.description)")
              .font(.custom("AmericanTypewriter", size: 25))
              .fontWeight(.bold)

            Spacer()

            AddToCartButtonView(
              store: self.store.scope(
                state: \.addToCartState,
                action: ProductFeature.Action.addToCart
              )
            )
          }
        }
        .font(.custom("AmericanTypewriter", size: 20))
      }
      .padding(20)
    }
  }
}

struct ProductCell_Previews: PreviewProvider {
  static var previews: some View {
    ProductCellView(
      store: .init(initialState: ProductFeature.State(
        id: UUID(),
        product: Product.sample[0])) {
          return ProductFeature()
        }
    )
    .previewLayout(.fixed(width: 300, height: 300))
  }
}
