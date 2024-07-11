// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct EventHostV2: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment EventHostV2 on Event { __typename id pairingType status shortCode isOnline eventFormat { ...EventFormatDetails __typename } registeredPlayers { ...RegistrationDetails __typename } }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Event }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", Gamestateschema.ID.self),
      .field("pairingType", GraphQLEnum<Gamestateschema.PairingType>.self),
      .field("status", GraphQLEnum<Gamestateschema.EventStatus>.self),
      .field("shortCode", String?.self),
      .field("isOnline", Bool?.self),
      .field("eventFormat", EventFormat?.self),
      .field("registeredPlayers", [RegisteredPlayer]?.self),
    ] }

    var id: Gamestateschema.ID { __data["id"] }
    /// The pairing method for the event.
    var pairingType: GraphQLEnum<Gamestateschema.PairingType> { __data["pairingType"] }
    /// Events are in the SCHEDULED status upon creation and until they are explicitly
    /// started by an authorized user. When they are started, they will transition to
    /// DRAFTING. When the first round is started, the event will move to ROUNDACTIVE
    /// and then ROUNDCERTIFIED once all scores for the round are recorded. It moves
    /// back and forth between ROUNDACTIVE and ROUNDCERTIFIED until the last round
    /// has been certified. When an authorized user ends the event, it will move to
    /// ENDED. An event will be CANCELLED only if it is deleted without ever having
    /// been started.
    var status: GraphQLEnum<Gamestateschema.EventStatus> { __data["status"] }
    /// A short (generally 6-character) string that uniquely identifies this event. Used
    /// by the player experience for easy event signup.
    var shortCode: String? { __data["shortCode"] }
    /// Whether this event is marked as an event that was run online.
    var isOnline: Bool? { __data["isOnline"] }
    /// The format of the event.
    var eventFormat: EventFormat? { __data["eventFormat"] }
    /// The list of people who have paid and been assigned a spot in the event.
    /// Event-Res calls this "registrations."
    var registeredPlayers: [RegisteredPlayer]? { __data["registeredPlayers"] }

    /// EventFormat
    ///
    /// Parent Type: `EventFormat`
    struct EventFormat: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.EventFormat }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(EventFormatDetails.self),
      ] }

      /// The type-specific, unique-identifier of this event format
      var id: Gamestateschema.ID { __data["id"] }
      /// The name of the format
      var name: String { __data["name"] }
      /// Whether events in this format include a Drafting phase
      var includesDraft: Bool { __data["includesDraft"] }
      /// Whether events in this format include a Deck Construction phase
      var includesDeckbuilding: Bool { __data["includesDeckbuilding"] }

      struct Fragments: FragmentContainer {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        var eventFormatDetails: EventFormatDetails { _toFragment() }
      }
    }

    /// RegisteredPlayer
    ///
    /// Parent Type: `Registration`
    struct RegisteredPlayer: Gamestateschema.SelectionSet {
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
  }

}