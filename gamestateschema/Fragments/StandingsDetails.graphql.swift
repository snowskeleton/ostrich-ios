// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct StandingsDetails: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment StandingsDetails on TeamStanding { __typename team { ...TeamDetails __typename } rank wins losses draws byes matchPoints gameWinPercent opponentGameWinPercent opponentMatchWinPercent }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.TeamStanding }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("team", Team.self),
      .field("rank", Int.self),
      .field("wins", Int.self),
      .field("losses", Int.self),
      .field("draws", Int.self),
      .field("byes", Int.self),
      .field("matchPoints", Int.self),
      .field("gameWinPercent", Double.self),
      .field("opponentGameWinPercent", Double.self),
      .field("opponentMatchWinPercent", Double.self),
    ] }

    /// The team that this standing is for.
    var team: Team { __data["team"] }
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
    /// The number of match byes the team has recorded in this event to date. Only includes
    /// results from certified rounds (i.e., not the round currently underway).
    var byes: Int { __data["byes"] }
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

    /// Team
    ///
    /// Parent Type: `Team`
    struct Team: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Team }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(TeamDetails.self),
      ] }

      /// The ID of the team.
      var id: Gamestateschema.ID { __data["id"] }
      /// The name of the team.
      var name: String? { __data["name"] }
      /// The players who make up the team.
      var players: [Player] { __data["players"] }
      /// Game level results
      var results: [Result]? { __data["results"] }

      struct Fragments: FragmentContainer {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        var teamDetails: TeamDetails { _toFragment() }
      }

      /// Team.Player
      ///
      /// Parent Type: `User`
      struct Player: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.User }

        /// The personaId of the user.
        var personaId: Gamestateschema.ID { __data["personaId"] }
        /// The user's display name as returned from Platform.
        var displayName: String? { __data["displayName"] }
        /// The user's first name.
        var firstName: String? { __data["firstName"] }
        /// The user's last name.
        var lastName: String? { __data["lastName"] }

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var userDetails: UserDetails { _toFragment() }
        }
      }

      /// Team.Result
      ///
      /// Parent Type: `TeamResult`
      struct Result: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.TeamResult }

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

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var resultDetails: ResultDetails { _toFragment() }
        }
      }
    }
  }

}