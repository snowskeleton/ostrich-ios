// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct RoundDetailsV2: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment RoundDetailsV2 on RoundV2 { __typename roundId roundNumber isFinalRound isPlayoff isCertified matches { ...MatchesDetailsV2 __typename } pairingStrategy canRollback timerId standings { ...TeamStandingsDetailsV2 __typename } }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.RoundV2 }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("roundId", Gamestateschema.ID.self),
      .field("roundNumber", Int.self),
      .field("isFinalRound", Bool?.self),
      .field("isPlayoff", Bool?.self),
      .field("isCertified", Bool?.self),
      .field("matches", [Match].self),
      .field("pairingStrategy", String?.self),
      .field("canRollback", Bool?.self),
      .field("timerId", Gamestateschema.ID?.self),
      .field("standings", [Standing].self),
    ] }

    /// A fabricated ID, used so that Apollo Client can easily cache Round objects.
    var roundId: Gamestateschema.ID { __data["roundId"] }
    /// The round number. The first round is numbered 1.
    var roundNumber: Int { __data["roundNumber"] }
    /// Is this the final round?
    var isFinalRound: Bool? { __data["isFinalRound"] }
    /// If this round is a Playoff round
    var isPlayoff: Bool? { __data["isPlayoff"] }
    /// Have this round's scores been certified?
    var isCertified: Bool? { __data["isCertified"] }
    /// The matches (pairings) for this round.
    var matches: [Match] { __data["matches"] }
    /// The pairingStrategy for this round.
    var pairingStrategy: String? { __data["pairingStrategy"] }
    /// Is this a round that the rollback option is available
    var canRollback: Bool? { __data["canRollback"] }
    /// GUID or UUID of that represents Timer ID of Timer GraphQL
    var timerId: Gamestateschema.ID? { __data["timerId"] }
    /// The standings for this round, based on completed and certified round. 
    var standings: [Standing] { __data["standings"] }

    /// Match
    ///
    /// Parent Type: `MatchV2`
    struct Match: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.MatchV2 }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(MatchesDetailsV2.self),
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

      struct Fragments: FragmentContainer {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        var matchesDetailsV2: MatchesDetailsV2 { _toFragment() }
      }

      /// Match.Result
      ///
      /// Parent Type: `TeamResultV2`
      struct Result: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.TeamResultV2 }

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

    /// Standing
    ///
    /// Parent Type: `TeamStandingV2`
    struct Standing: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.TeamStandingV2 }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(TeamStandingsDetailsV2.self),
      ] }

      /// The id of the team that this standing is for.
      var teamId: Gamestateschema.ID { __data["teamId"] }
      /// The rank of this standing in the scope of the event. The team with the best record
      /// has rank 1, the second-best rank 2, and so on up to the number of teams in the event.
      /// Even if two teams have identical records, their ranks will still differ due to our
      /// various tiebreaker rules.
      var rank: Int { __data["rank"] }
      /// The number of match wins the team has recorded in this event to date. Only includes
      /// results from certified rounds (i.e., not the round currently underway).
      var wins: Int { __data["wins"] }
      /// The number of match losses the team has recorded in this event to date. Only includes
      /// results from certified rounds (i.e., not the round currently underway).
      var losses: Int { __data["losses"] }
      /// The number of match draws the team has recorded in this event to date. Only includes
      /// results from certified rounds (i.e., not the round currently underway).
      var draws: Int { __data["draws"] }
      /// The number of points the team has scored so far in this event.
      var matchPoints: Int { __data["matchPoints"] }
      /// The team's gameWinPercent. See the Magic Tournament Rules for more information on
      /// how this is calculated.
      var gameWinPercent: Double { __data["gameWinPercent"] }
      /// The opponentGameWinPercent. See the Magic Tournament Rules for more information on
      /// how this is calculated.
      var opponentGameWinPercent: Double { __data["opponentGameWinPercent"] }
      /// The opponentMatchWinPercent. See the Magic Tournament Rules for more information on
      /// how this is calculated.
      var opponentMatchWinPercent: Double { __data["opponentMatchWinPercent"] }

      struct Fragments: FragmentContainer {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        var teamStandingsDetailsV2: TeamStandingsDetailsV2 { _toFragment() }
      }
    }
  }

}