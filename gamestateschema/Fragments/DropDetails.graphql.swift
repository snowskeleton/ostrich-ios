// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct DropDetails: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment DropDetails on Drop { __typename teamId roundNumber }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Drop }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("teamId", Gamestateschema.ID.self),
      .field("roundNumber", Int.self),
    ] }

    /// The ID of the team that dropped.
    var teamId: Gamestateschema.ID { __data["teamId"] }
    /// The last round number that the team participated in. Will be 0 if the team dropped
    /// before pairing for the first round.
    var roundNumber: Int { __data["roundNumber"] }
  }

}