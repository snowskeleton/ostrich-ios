// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct OrganizationDetails: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment OrganizationDetails on Organization { __typename id name latitude longitude phoneNumber isPremium postalAddress website }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Organization }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", Gamestateschema.ID.self),
      .field("name", String.self),
      .field("latitude", Double?.self),
      .field("longitude", Double?.self),
      .field("phoneNumber", String?.self),
      .field("isPremium", Bool?.self),
      .field("postalAddress", String.self),
      .field("website", String?.self),
    ] }

    var id: Gamestateschema.ID { __data["id"] }
    /// The name of the organization.
    var name: String { __data["name"] }
    /// The latitude of the organization's primary location.
    var latitude: Double? { __data["latitude"] }
    /// The longitude of the organization's primary location.
    var longitude: Double? { __data["longitude"] }
    /// The organization's primary phone number.
    var phoneNumber: String? { __data["phoneNumber"] }
    /// `true` if the organization has Premium status.
    var isPremium: Bool? { __data["isPremium"] }
    /// The primary postal address of the organization.
    var postalAddress: String { __data["postalAddress"] }
    /// The organization's primary web site URL.
    var website: String? { __data["website"] }
  }

}