// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct TeamStandingsDetailsV2: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment TeamStandingsDetailsV2 on TeamStandingV2 { __typename teamId rank wins losses draws matchPoints gameWinPercent opponentGameWinPercent opponentMatchWinPercent }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.TeamStandingV2 }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("teamId", Gamestateschema.ID.self),
      .field("rank", Int.self),
      .field("wins", Int.self),
      .field("losses", Int.self),
      .field("draws", Int.self),
      .field("matchPoints", Int.self),
      .field("gameWinPercent", Double.self),
      .field("opponentGameWinPercent", Double.self),
      .field("opponentMatchWinPercent", Double.self),
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
  }

}