// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension Gamestateschema {
  struct TeamResultInputV2: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      matchId: ID,
      submitter: GraphQLNullable<ID> = nil,
      isBye: Bool,
      wins: Int,
      losses: Int,
      draws: Int,
      teamId: ID
    ) {
      __data = InputDict([
        "matchId": matchId,
        "submitter": submitter,
        "isBye": isBye,
        "wins": wins,
        "losses": losses,
        "draws": draws,
        "teamId": teamId
      ])
    }

    /// Id of the match for the submitted results
    var matchId: ID {
      get { __data["matchId"] }
      set { __data["matchId"] = newValue }
    }

    /// OPTIONAL If not given the server will figure out who submitted this result
    /// The Persona id of the submitter for this result
    var submitter: GraphQLNullable<ID> {
      get { __data["submitter"] }
      set { __data["submitter"] = newValue }
    }

    /// Is this result a bye
    var isBye: Bool {
      get { __data["isBye"] }
      set { __data["isBye"] = newValue }
    }

    /// The current results wins
    var wins: Int {
      get { __data["wins"] }
      set { __data["wins"] = newValue }
    }

    /// The current results losses
    var losses: Int {
      get { __data["losses"] }
      set { __data["losses"] = newValue }
    }

    /// holds game-level draws
    var draws: Int {
      get { __data["draws"] }
      set { __data["draws"] = newValue }
    }

    /// The id for which team this result applies to
    var teamId: ID {
      get { __data["teamId"] }
      set { __data["teamId"] = newValue }
    }
  }
}
