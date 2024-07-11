// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class UnRegisterPlayerMutation: GraphQLMutation {
    static let operationName: String = "unRegisterPlayer"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation unRegisterPlayer($eventId: ID!, $registrationId: ID!) { removeRegisteredPlayer(eventId: $eventId, id: $registrationId) { __typename id } }"#
      ))

    public var eventId: ID
    public var registrationId: ID

    public init(
      eventId: ID,
      registrationId: ID
    ) {
      self.eventId = eventId
      self.registrationId = registrationId
    }

    public var __variables: Variables? { [
      "eventId": eventId,
      "registrationId": registrationId
    ] }

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("removeRegisteredPlayer", RemoveRegisteredPlayer?.self, arguments: [
          "eventId": .variable("eventId"),
          "id": .variable("registrationId")
        ]),
      ] }

      /// Remove a player from the registered list. If the player was previously on the interested list,
      /// they will return to it. `id` is the ID of the Registration.
      ///
      /// TODO: remove requirement to pass `eventId`
      var removeRegisteredPlayer: RemoveRegisteredPlayer? { __data["removeRegisteredPlayer"] }

      /// RemoveRegisteredPlayer
      ///
      /// Parent Type: `Event`
      struct RemoveRegisteredPlayer: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Event }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", Gamestateschema.ID.self),
        ] }

        var id: Gamestateschema.ID { __data["id"] }
      }
    }
  }

}