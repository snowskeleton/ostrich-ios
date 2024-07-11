// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class GetPlayerStatusQuery: GraphQLQuery {
    static let operationName: String = "getPlayerStatus"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query getPlayerStatus($eventId: ID!) { playerStatus(eventId: $eventId) }"#
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
        .field("playerStatus", GraphQLEnum<Gamestateschema.PlayerStatus>.self, arguments: ["eventId": .variable("eventId")]),
      ] }

      /// Get player event status for current user.
      var playerStatus: GraphQLEnum<Gamestateschema.PlayerStatus> { __data["playerStatus"] }
    }
  }

}