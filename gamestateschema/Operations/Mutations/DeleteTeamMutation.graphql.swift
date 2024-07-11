// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class DeleteTeamMutation: GraphQLMutation {
    static let operationName: String = "deleteTeam"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation deleteTeam($eventId: ID!, $teamCode: String!) { deleteTeam(eventId: $eventId, teamCode: $teamCode) }"#
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
        .field("deleteTeam", String?.self, arguments: [
          "eventId": .variable("eventId"),
          "teamCode": .variable("teamCode")
        ]),
      ] }

      /// Deletes team from event
      var deleteTeam: String? { __data["deleteTeam"] }
    }
  }

}