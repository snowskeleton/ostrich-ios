// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class GetRegisteredPlayersListQuery: GraphQLQuery {
    static let operationName: String = "getRegisteredPlayersList"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query getRegisteredPlayersList($eventId: ID!) { event(id: $eventId) { __typename registeredPlayers { ...RegistrationDetails __typename } } }"#,
        fragments: [RegistrationDetails.self]
      ))

    public var eventId: ID

    public init(eventId: ID) {
      self.eventId = eventId
    }

    public var __variables: Variables? { ["eventId": eventId] }

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("event", Event?.self, arguments: ["id": .variable("eventId")]),
      ] }

      /// Get an event by ID.
      var event: Event? { __data["event"] }

      /// Event
      ///
      /// Parent Type: `Event`
      struct Event: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Event }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("registeredPlayers", [RegisteredPlayer]?.self),
        ] }

        /// The list of people who have paid and been assigned a spot in the event.
        /// Event-Res calls this "registrations."
        var registeredPlayers: [RegisteredPlayer]? { __data["registeredPlayers"] }

        /// Event.RegisteredPlayer
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
  }

}