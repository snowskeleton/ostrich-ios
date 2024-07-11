// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct RegistrationDetails: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment RegistrationDetails on Registration { __typename id status personaId displayName firstName lastName }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Registration }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", Gamestateschema.ID.self),
      .field("status", GraphQLEnum<Gamestateschema.PlatformStatus>?.self),
      .field("personaId", Gamestateschema.ID?.self),
      .field("displayName", String?.self),
      .field("firstName", String?.self),
      .field("lastName", String?.self),
    ] }

    /// The ID of the registration. BEWARE: the ID of a registration of an interestedPlayer may match
    /// the ID of a registration of a *different* registeredPlayer. This is expected to be OK because
    /// we don't provide any mutations that refer to the ID of an interestedPlayer.
    var id: Gamestateschema.ID { __data["id"] }
    /// Whether we found a Wizards account matching this registrant, or created a guest account for them.
    var status: GraphQLEnum<Gamestateschema.PlatformStatus>? { __data["status"] }
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