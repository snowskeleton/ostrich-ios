// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class DropTeamsV2Mutation: GraphQLMutation {
    static let operationName: String = "dropTeamsV2"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation dropTeamsV2($eventId: ID!, $teamIds: [ID!]!) { dropTeamsV2(eventId: $eventId, teamIds: $teamIds) }"#
      ))

    public var eventId: ID
    public var teamIds: [ID]

    public init(
      eventId: ID,
      teamIds: [ID]
    ) {
      self.eventId = eventId
      self.teamIds = teamIds
    }

    public var __variables: Variables? { [
      "eventId": eventId,
      "teamIds": teamIds
    ] }

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("dropTeamsV2", Gamestateschema.Void?.self, arguments: [
          "eventId": .variable("eventId"),
          "teamIds": .variable("teamIds")
        ]),
      ] }

      /// Drop multiple team from the current round. The team will not be paired in the next round, and
      /// any unplayed games will be credited to their opponent (assuming the opponent has not also
      /// dropped).
      var dropTeamsV2: Gamestateschema.Void? { __data["dropTeamsV2"] }
    }
  }

}