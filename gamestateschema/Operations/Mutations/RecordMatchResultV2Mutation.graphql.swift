// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class RecordMatchResultV2Mutation: GraphQLMutation {
    static let operationName: String = "recordMatchResultV2"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation recordMatchResultV2($eventId: ID!, $results: [TeamResultInputV2!]!) { recordMatchResultV2(eventId: $eventId, results: $results) }"#
      ))

    public var eventId: ID
    public var results: [TeamResultInputV2]

    public init(
      eventId: ID,
      results: [TeamResultInputV2]
    ) {
      self.eventId = eventId
      self.results = results
    }

    public var __variables: Variables? { [
      "eventId": eventId,
      "results": results
    ] }

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("recordMatchResultV2", Gamestateschema.Void?.self, arguments: [
          "eventId": .variable("eventId"),
          "results": .variable("results")
        ]),
      ] }

      /// Record the result of a single match in a round. The result is assumed to be final; that is,
      /// the client should not send game results one at a time as the games are finished, but
      /// instead wait until the match has concluded and send a match score. Returns the current
      /// GameState.
      /// An optional roundNumber can be added to modify a result from the previous round
      var recordMatchResultV2: Gamestateschema.Void? { __data["recordMatchResultV2"] }
    }
  }

}