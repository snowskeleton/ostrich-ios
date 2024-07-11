// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct ResultDetails: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment ResultDetails on TeamResult { __typename draws isPlayoffResult submitter isFinal isTO isBye wins losses teamId }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.TeamResult }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("draws", Int.self),
      .field("isPlayoffResult", Bool?.self),
      .field("submitter", Gamestateschema.ID.self),
      .field("isFinal", Bool?.self),
      .field("isTO", Bool?.self),
      .field("isBye", Bool?.self),
      .field("wins", Int?.self),
      .field("losses", Int?.self),
      .field("teamId", Gamestateschema.ID.self),
    ] }

    /// holds game-level draws
    var draws: Int { __data["draws"] }
    /// Is this result currently a playoff result
    var isPlayoffResult: Bool? { __data["isPlayoffResult"] }
    /// The Persona id of the submitter for this result
    var submitter: Gamestateschema.ID { __data["submitter"] }
    /// Is this a final result
    var isFinal: Bool? { __data["isFinal"] }
    /// Is the submitter a TO
    var isTO: Bool? { __data["isTO"] }
    /// Is this result a bye
    var isBye: Bool? { __data["isBye"] }
    /// The current results wins
    var wins: Int? { __data["wins"] }
    /// The current results losses
    var losses: Int? { __data["losses"] }
    /// The id for which team this result applies to
    var teamId: Gamestateschema.ID { __data["teamId"] }
  }

}