// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class MatchFoundSubscription: GraphQLSubscription {
    static let operationName: String = "matchFound"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"subscription matchFound($eventId: ID!, $personaId: String!) { matchFound(eventId: $eventId, personaId: $personaId) { __typename eventId queueIds matchId personaIds tableNumber } }"#
      ))

    public var eventId: ID
    public var personaId: String

    public init(
      eventId: ID,
      personaId: String
    ) {
      self.eventId = eventId
      self.personaId = personaId
    }

    public var __variables: Variables? { [
      "eventId": eventId,
      "personaId": personaId
    ] }

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Subscription }
      static var __selections: [ApolloAPI.Selection] { [
        .field("matchFound", MatchFound.self, arguments: [
          "eventId": .variable("eventId"),
          "personaId": .variable("personaId")
        ]),
      ] }

      /// When a queue has been fired and a match has been created. Used by players to only get their match updates.
      var matchFound: MatchFound { __data["matchFound"] }

      /// MatchFound
      ///
      /// Parent Type: `MatchFoundPayload`
      struct MatchFound: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.MatchFoundPayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("eventId", Gamestateschema.ID.self),
          .field("queueIds", [Gamestateschema.ID]?.self),
          .field("matchId", Gamestateschema.ID.self),
          .field("personaIds", [String].self),
          .field("tableNumber", Int.self),
        ] }

        /// The id of the event.
        var eventId: Gamestateschema.ID { __data["eventId"] }
        /// The queue(s) that fired the event.
        var queueIds: [Gamestateschema.ID]? { __data["queueIds"] }
        /// The id of the created match.
        var matchId: Gamestateschema.ID { __data["matchId"] }
        /// Players in the newly created match.
        var personaIds: [String] { __data["personaIds"] }
        /// Table number for the new match.
        var tableNumber: Int { __data["tableNumber"] }
      }
    }
  }

}