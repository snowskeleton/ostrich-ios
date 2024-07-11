// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class LeaveQueueMutation: GraphQLMutation {
    static let operationName: String = "leaveQueue"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation leaveQueue($eventId: ID!, $queueId: ID!, $personaId: String!) { leaveQueue(eventId: $eventId, queueId: $queueId, personaId: $personaId) }"#
      ))

    public var eventId: ID
    public var queueId: ID
    public var personaId: String

    public init(
      eventId: ID,
      queueId: ID,
      personaId: String
    ) {
      self.eventId = eventId
      self.queueId = queueId
      self.personaId = personaId
    }

    public var __variables: Variables? { [
      "eventId": eventId,
      "queueId": queueId,
      "personaId": personaId
    ] }

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("leaveQueue", Gamestateschema.Void?.self, arguments: [
          "eventId": .variable("eventId"),
          "queueId": .variable("queueId"),
          "personaId": .variable("personaId")
        ]),
      ] }

      /// Removes player from queue
      var leaveQueue: Gamestateschema.Void? { __data["leaveQueue"] }
    }
  }

}