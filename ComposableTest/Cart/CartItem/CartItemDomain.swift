//
//  CartItemDomain.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 01.11.2023.
//

import Foundation
import ComposableArchitecture

struct CartItemDomain: Reducer {
  
  struct State: Equatable, Identifiable {
    let id: UUID
    let cartItem: CartItem
  }

  enum Action: Equatable {
    case deleteCartItem(product: Product)
  }
  
  // MARK: - Reducer
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      default: break
      }
    return .none
  }
}


struct CartItem: Equatable {
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
