//
//  ComposableTestApp.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 19.10.2023.
//

import SwiftUI

@main
struct ComposableTestApp: App {
    var body: some Scene {
        WindowGroup {
          ProductListView(store: .init(
            initialState: ProductListFeature.State()
          ) {
            ProductListFeature(
              fetchProducts: { Product.sample },
              uuid: { UUID() }
            )
          })
        }
    }
}
