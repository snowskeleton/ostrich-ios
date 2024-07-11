// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct TeamResultDetailsV2: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment TeamResultDetailsV2 on TeamResultV2 { __typename matchId submitter isBye wins losses draws teamId }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.TeamResultV2 }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("matchId", Gamestateschema.ID.self),
      .field("submitter", Gamestateschema.ID.self),
      .field("isBye", Bool.self),
      .field("wins", Int.self),
      .field("losses", Int.self),
      .field("draws", Int.self),
      .field("teamId", Gamestateschema.ID.self),
    ] }

    /// Id of the match for the result
    var matchId: Gamestateschema.ID { __data["matchId"] }
    /// The Persona id of the submitter for this result
    var submitter: Gamestateschema.ID { __data["submitter"] }
    /// Is this result a bye
    var isBye: Bool { __data["isBye"] }
    /// The current results wins
    var wins: Int { __data["wins"] }
    /// The current results losses
    var losses: Int { __data["losses"] }
    /// holds game-level draws
    var draws: Int { __data["draws"] }
    /// The id for which team this result applies to
    var teamId: Gamestateschema.ID { __data["teamId"] }
  }

}