// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct UserDetails: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment UserDetails on User { __typename personaId displayName firstName lastName }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.User }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("personaId", Gamestateschema.ID.self),
      .field("displayName", String?.self),
      .field("firstName", String?.self),
      .field("lastName", String?.self),
    ] }

    /// The personaId of the user.
    var personaId: Gamestateschema.ID { __data["personaId"] }
    /// The user's display name as returned from Platform.
    var displayName: String? { __data["displayName"] }
    /// The user's first name.
    var firstName: String? { __data["firstName"] }
    /// The user's last name.
    var lastName: String? { __data["lastName"] }
  }

}