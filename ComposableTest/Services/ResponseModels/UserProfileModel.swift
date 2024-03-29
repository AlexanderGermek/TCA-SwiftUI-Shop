//
//  UserProfileModel.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 21.01.2024.
//

import Foundation

struct UserProfileModel: Equatable {
	let id: Int
	let email: String
	let firstName: String
	let lastName: String
}

extension UserProfileModel: Decodable {
	private enum ProfileKeys: String, CodingKey {
		case id
		case email
		case name
		case firstname
		case lastname
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ProfileKeys.self)
		self.id = try container.decode(Int.self, forKey: .id)
		self.email = try container.decode(String.self, forKey: .email)

		let nameContainer = try container.nestedContainer(keyedBy: ProfileKeys.self, forKey: .name)
		self.firstName = try nameContainer.decode(String.self, forKey: .firstname)
		self.lastName = try nameContainer.decode(String.self, forKey: .lastname)
	}
}

extension UserProfileModel {
	static var sample: UserProfileModel {
		.init(
			id: 1,
			email: "hello@test.com",
			firstName: "Alex",
			lastName: "Germek"
		)
	}

	static var `default`: UserProfileModel {
		.init(
			id: 0,
			email: "",
			firstName: "",
			lastName: ""
		)
	}
}
