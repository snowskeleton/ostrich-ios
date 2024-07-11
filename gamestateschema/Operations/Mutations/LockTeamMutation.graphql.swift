// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class LockTeamMutation: GraphQLMutation {
    static let operationName: String = "lockTeam"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation lockTeam($eventId: ID!, $teamCode: String!) { lockTeam(eventId: $eventId, teamCode: $teamCode) { ...TeamFields __typename } }"#,
        fragments: [RegistrationDetails.self, ReservationDetails.self, TeamFields.self]
      ))

    public var eventId: ID
    public var teamCode: String

    public init(
      eventId: ID,
      teamCode: String
    ) {
      self.eventId = eventId
      self.teamCode = teamCode
    }

    public var __variables: Variables? { [
      "eventId": eventId,
      "teamCode": teamCode
    ] }

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("lockTeam", LockTeam.self, arguments: [
          "eventId": .variable("eventId"),
          "teamCode": .variable("teamCode")
        ]),
      ] }

      /// Locks team and keeps new players from joining
      var lockTeam: LockTeam { __data["lockTeam"] }

      /// LockTeam
      ///
      /// Parent Type: `TeamPayload`
      struct LockTeam: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.TeamPayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(TeamFields.self),
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

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var teamFields: TeamFields { _toFragment() }
        }

        /// LockTeam.Registration
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

        /// LockTeam.Reservation
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