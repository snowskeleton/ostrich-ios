// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class CreatePrivateEventMutation: GraphQLMutation {
    static let operationName: String = "createPrivateEvent"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation createPrivateEvent($input: CreatePrivateEventInput!) { createPrivateEvent(input: $input) { __typename id } }"#
      ))

    public var input: CreatePrivateEventInput

    public init(input: CreatePrivateEventInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("createPrivateEvent", CreatePrivateEvent?.self, arguments: ["input": .variable("input")]),
      ] }

      /// Create a new Private Event
      var createPrivateEvent: CreatePrivateEvent? { __data["createPrivateEvent"] }

      /// CreatePrivateEvent
      ///
      /// Parent Type: `PrivateEvent`
      struct CreatePrivateEvent: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.PrivateEvent }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", Gamestateschema.ID.self),
        ] }

        /// EventID
        var id: Gamestateschema.ID { __data["id"] }
      }
    }
  }

}