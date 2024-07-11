// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class DropSelfV2Mutation: GraphQLMutation {
    static let operationName: String = "dropSelfV2"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation dropSelfV2($eventId: ID!) { dropSelfV2(eventId: $eventId) }"#
      ))

    public var eventId: ID

    public init(eventId: ID) {
      self.eventId = eventId
    }

    public var __variables: Variables? { ["eventId": eventId] }

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("dropSelfV2", Gamestateschema.Void?.self, arguments: ["eventId": .variable("eventId")]),
      ] }

      /// Drop yourself as a player from the match / event
      var dropSelfV2: Gamestateschema.Void? { __data["dropSelfV2"] }
    }
  }

}