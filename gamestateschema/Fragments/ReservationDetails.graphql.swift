// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct ReservationDetails: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment ReservationDetails on Registration { __typename personaId displayName firstName lastName }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Registration }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("personaId", Gamestateschema.ID?.self),
      .field("displayName", String?.self),
      .field("firstName", String?.self),
      .field("lastName", String?.self),
    ] }

    /// The persona ID of this registrant, if they have a Wizards account; i.e., if their status is FOUND or GUEST.
    var personaId: Gamestateschema.ID? { __data["personaId"] }
    /// The registrant's display name as returned from Platform.
    var displayName: String? { __data["displayName"] }
    /// The registrant's first name.
    var firstName: String? { __data["firstName"] }
    /// The registrant's last name.
    var lastName: String? { __data["lastName"] }
  }

}