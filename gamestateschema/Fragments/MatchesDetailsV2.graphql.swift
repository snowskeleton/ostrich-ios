// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct MatchesDetailsV2: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment MatchesDetailsV2 on MatchV2 { __typename matchId isBye teamIds results { ...TeamResultDetailsV2 __typename } tableNumber }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.MatchV2 }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("matchId", Gamestateschema.ID.self),
      .field("isBye", Bool?.self),
      .field("teamIds", [Gamestateschema.ID].self),
      .field("results", [Result]?.self),
      .field("tableNumber", Int?.self),
    ] }

    /// The ID of the match.
    var matchId: Gamestateschema.ID { __data["matchId"] }
    /// Is this match a bye?
    var isBye: Bool? { __data["isBye"] }
    /// The teams participating in this match. By convention the first time in this array is
    /// the 'left' team, and the second is the 'right' team. This will need to change when
    /// we support multi-team games such as Commander.
    var teamIds: [Gamestateschema.ID] { __data["teamIds"] }
    /// Match results for all teams
    var results: [Result]? { __data["results"] }
    /// The table number at which the match will be played.
    var tableNumber: Int? { __data["tableNumber"] }

    /// Result
    ///
    /// Parent Type: `TeamResultV2`
    struct Result: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.TeamResultV2 }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(TeamResultDetailsV2.self),
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

      struct Fragments: FragmentContainer {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        var teamResultDetailsV2: TeamResultDetailsV2 { _toFragment() }
      }
    }
  }

}