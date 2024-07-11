// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct TeamFields: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment TeamFields on TeamPayload { __typename id eventId teamCode isLocked isRegistered registrations { ...RegistrationDetails __typename } reservations { ...ReservationDetails __typename } }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.TeamPayload }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", Gamestateschema.ID.self),
      .field("eventId", Gamestateschema.ID.self),
      .field("teamCode", String.self),
      .field("isLocked", Bool?.self),
      .field("isRegistered", Bool?.self),
      .field("registrations", [Registration]?.self),
      .field("reservations", [Reservation]?.self),
    ] }

    /// The ID of the team.
    var id: Gamestateschema.ID { __data["id"] }
    /// The ID of the event.
    var eventId: Gamestateschema.ID { __data["eventId"] }
    /// The sort code to identify the team for joining
    var teamCode: String { __data["teamCode"] }
    /// Determines if team is joinable
    var isLocked: Bool? { __data["isLocked"] }
    /// Determines if team is registered.
    var isRegistered: Bool? { __data["isRegistered"] }
    /// List of players in team registered for the event.
    var registrations: [Registration]? { __data["registrations"] }
    /// List of players in team reserved for the event.
    var reservations: [Reservation]? { __data["reservations"] }

    /// Registration
    ///
    /// Parent Type: `Registration`
    struct Registration: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Registration }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(RegistrationDetails.self),
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

      struct Fragments: FragmentContainer {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        var registrationDetails: RegistrationDetails { _toFragment() }
      }
    }

    /// Reservation
    ///
    /// Parent Type: `Registration`
    struct Reservation: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Registration }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(ReservationDetails.self),
      ] }

      /// The persona ID of this registrant, if they have a Wizards account; i.e., if their status is FOUND or GUEST.
      var personaId: Gamestateschema.ID? { __data["personaId"] }
      /// The registrant's display name as returned from Platform.
      var displayName: String? { __data["displayName"] }
      /// The registrant's first name.
      var firstName: String? { __data["firstName"] }
      /// The registrant's last name.
      var lastName: String? { __data["lastName"] }

      struct Fragments: FragmentContainer {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        var reservationDetails: ReservationDetails { _toFragment() }
      }
    }
  }

}