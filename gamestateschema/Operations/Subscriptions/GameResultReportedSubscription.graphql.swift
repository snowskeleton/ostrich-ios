// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class GameResultReportedSubscription: GraphQLSubscription {
    static let operationName: String = "gameResultReported"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"subscription gameResultReported($eventId: ID!) { gameResultReported(eventId: $eventId) { __typename eventId sender { ...UserDetails __typename } } }"#,
        fragments: [UserDetails.self]
      ))

    public var eventId: ID

    public init(eventId: ID) {
      self.eventId = eventId
    }

    public var __variables: Variables? { ["eventId": eventId] }

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Subscription }
      static var __selections: [ApolloAPI.Selection] { [
        .field("gameResultReported", GameResultReported.self, arguments: ["eventId": .variable("eventId")]),
      ] }

      /// When a result has been reported for an event
      var gameResultReported: GameResultReported { __data["gameResultReported"] }

      /// GameResultReported
      ///
      /// Parent Type: `GamekeeperResultsNotificationPayload`
      struct GameResultReported: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.GamekeeperResultsNotificationPayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("eventId", Gamestateschema.ID.self),
          .field("sender", Sender?.self),
        ] }

        /// The id of the event that was created
        var eventId: Gamestateschema.ID { __data["eventId"] }
        /// The user who updated the game result
        var sender: Sender? { __data["sender"] }

        /// GameResultReported.Sender
        ///
        /// Parent Type: `User`
        struct Sender: Gamestateschema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.User }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(UserDetails.self),
          ] }

          /// The personaId of the user.
          var personaId: Gamestateschema.ID { __data["personaId"] }
          /// The user's display name as returned from Platform.
          var displayName: String? { __data["displayName"] }
          /// The user's first name.
          var firstName: String? { __data["firstName"] }
          /// The user's last name.
          var lastName: String? { __data["lastName"] }

          struct Fragments: FragmentContainer {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            var userDetails: UserDetails { _toFragment() }
          }
        }
      }
    }
  }

}