// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class LoadEventJoinV2Query: GraphQLQuery {
    static let operationName: String = "loadEventJoinV2"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query loadEventJoinV2($eventId: ID!) { event(id: $eventId) { ...EventJoinV2 __typename } }"#,
        fragments: [EventFormatDetails.self, EventJoinV2.self, RegistrationDetails.self, ReservationDetails.self, TeamFields.self]
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
          .fragment(EventJoinV2.self),
        ] }

        var id: Gamestateschema.ID { __data["id"] }
        /// The title of the event.
        var title: String { __data["title"] }
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
        /// Whether this event is marked as an event that was run online.
        var isOnline: Bool? { __data["isOnline"] }
        /// The persona id of the user that created this event.
        var createdBy: Gamestateschema.ID? { __data["createdBy"] }
        /// The number of players per team in the event.
        var requiredTeamSize: Int { __data["requiredTeamSize"] }
        /// The format of the event.
        var eventFormat: EventFormat? { __data["eventFormat"] }
        /// Get all the current teams for an event
        var teams: [Team] { __data["teams"] }

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var eventJoinV2: EventJoinV2 { _toFragment() }
        }

        /// Event.EventFormat
        ///
        /// Parent Type: `EventFormat`
        struct EventFormat: Gamestateschema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.EventFormat }

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

        /// Event.Team
        ///
        /// Parent Type: `TeamPayload`
        struct Team: Gamestateschema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.TeamPayload }

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

          struct Fragments: FragmentContainer {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            var teamFields: TeamFields { _toFragment() }
          }

          /// Event.Team.Registration
          ///
          /// Parent Type: `Registration`
          struct Registration: Gamestateschema.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Registration }

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

          /// Event.Team.Reservation
          ///
          /// Parent Type: `Registration`
          struct Reservation: Gamestateschema.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Registration }

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
    }
  }

}