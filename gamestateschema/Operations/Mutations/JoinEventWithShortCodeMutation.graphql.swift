// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class JoinEventWithShortCodeMutation: GraphQLMutation {
    static let operationName: String = "joinEventWithShortCode"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation joinEventWithShortCode($shortCode: String!) { joinEventWithShortCode(shortCode: $shortCode) }"#
      ))

    public var shortCode: String

    public init(shortCode: String) {
      self.shortCode = shortCode
    }

    public var __variables: Variables? { ["shortCode": shortCode] }

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("joinEventWithShortCode", Gamestateschema.ID.self, arguments: ["shortCode": .variable("shortCode")]),
      ] }

      /// Reserve a spot for an Event with a short code
      var joinEventWithShortCode: Gamestateschema.ID { __data["joinEventWithShortCode"] }
    }
  }

}