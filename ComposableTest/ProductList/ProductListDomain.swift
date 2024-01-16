//
//  ProductListFeature.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 19.10.2023.
//

import ComposableArchitecture
import SwiftUI

struct ProductListFeature: Reducer {

  // MARK: - State
  struct State: Equatable {
    var productListState: IdentifiedArrayOf<ProductFeature.State> = []
    @PresentationState var cartOpenedState: CartListFeature.State?
  }

  // MARK: - Action
  enum Action: Equatable {
    case loadProducts
    case loadProductsSuccess(TaskResult<[Product]>)
    case product(
      id: ProductFeature.State.ID,
      action: ProductFeature.Action
    )
    case goToCartButtonTapped // setCartView(isPresented)
    case cart(CartListFeature.Action)
    case cartOpenedAction(PresentationAction<CartListFeature.Action>)
  }

  // MARK: - Environment
  var fetchProducts: @Sendable () async throws -> [Product]
  var uuid: @Sendable () -> UUID

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {

      case .loadProducts:
        return .run { send in
          let result = await TaskResult { try await fetchProducts() }
          await send(.loadProductsSuccess(result))
        }

      case .loadProductsSuccess(.success(let products)):
        state.productListState = IdentifiedArrayOf(
          uniqueElements: products.map
          {
            ProductFeature.State(
              id: uuid(),
              product: $0)
          }
        )
        return .none
      case .loadProductsSuccess(.failure(let error)):
        print("Error getting products = \(error)")
        return .none
      case .product:
        return .none
      case .goToCartButtonTapped:
        state.cartOpenedState =
        CartListFeature.State(
          cartItems: IdentifiedArrayOf(
            uniqueElements: state.productListState.compactMap {
              $0.count > 0 ?
              CartItemFeature.State(
                id: UUID(),
                cartItem: CartItem(product: $0.product, quantity: $0.count)
              ) : nil
            }))
        return .none
      case .cart(let action):
        switch action {
        case .didPressCloseButton:
          state.cartOpenedState = nil
        }
        return .none
      case .cartOpenedAction:
        return .none
      }

    }
    .forEach(\.productListState, action: /ProductListFeature.Action.product(id:action:)) {
      ProductFeature()
    }
    .ifLet(\.$cartOpenedState, action: /ProductListFeature.Action.cartOpenedAction) {
      CartListFeature()
    }
  }
}
