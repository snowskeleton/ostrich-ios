// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class EndEventV2Mutation: GraphQLMutation {
    static let operationName: String = "endEventV2"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation endEventV2($eventId: ID!) { endEventV2(eventId: $eventId) }"#
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
        .field("endEventV2", Gamestateschema.Void?.self, arguments: ["eventId": .variable("eventId")]),
      ] }

      /// End an event. Will update the event status to ENDED, and set its actualEndTime.
      var endEventV2: Gamestateschema.Void? { __data["endEventV2"] }
    }
  }

}