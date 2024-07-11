// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class RegisterAnonymousPlayerMutation: GraphQLMutation {
    static let operationName: String = "registerAnonymousPlayer"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation registerAnonymousPlayer($eventId: ID!, $firstName: String!, $lastName: String!) { registerGuestPlayer( eventId: $eventId firstName: $firstName lastName: $lastName ) { ...RegisterPlayer __typename } }"#,
        fragments: [RegisterPlayer.self, RegistrationDetails.self]
      ))

    public var eventId: ID
    public var firstName: String
    public var lastName: String

    public init(
      eventId: ID,
      firstName: String,
      lastName: String
    ) {
      self.eventId = eventId
      self.firstName = firstName
      self.lastName = lastName
    }

    public var __variables: Variables? { [
      "eventId": eventId,
      "firstName": firstName,
      "lastName": lastName
    ] }

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("registerGuestPlayer", RegisterGuestPlayer?.self, arguments: [
          "eventId": .variable("eventId"),
          "firstName": .variable("firstName"),
          "lastName": .variable("lastName")
        ]),
      ] }

      /// Register a new guest (anonymous) player for the event.
      var registerGuestPlayer: RegisterGuestPlayer? { __data["registerGuestPlayer"] }

      /// RegisterGuestPlayer
      ///
      /// Parent Type: `Event`
      struct RegisterGuestPlayer: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Event }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(RegisterPlayer.self),
        ] }

        var id: Gamestateschema.ID { __data["id"] }
        /// The list of people who have paid and been assigned a spot in the event.
        /// Event-Res calls this "registrations."
        var registeredPlayers: [RegisteredPlayer]? { __data["registeredPlayers"] }

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var registerPlayer: RegisterPlayer { _toFragment() }
        }

        /// RegisterGuestPlayer.RegisteredPlayer
        ///
        /// Parent Type: `Registration`
        struct RegisteredPlayer: Gamestateschema.SelectionSet {
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
      }
    }
  }

}