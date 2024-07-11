// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct GameStateDetailsV2: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment GameStateDetailsV2 on GameStateV2 { __typename eventId minRounds draft { ...DraftPod __typename } top8Draft { ...DraftPod __typename } deckConstruction { ...DeckConstructionDetails __typename } currentRoundNumber rounds { ...RoundDetailsV2 __typename } teams { ...TeamDetailsV2 __typename } drops { ...DropDetailsV2 __typename } podPairingType gamesToWin }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.GameStateV2 }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("eventId", Gamestateschema.ID.self),
      .field("minRounds", Int?.self),
      .field("draft", Draft?.self),
      .field("top8Draft", Top8Draft?.self),
      .field("deckConstruction", DeckConstruction?.self),
      .field("currentRoundNumber", Int.self),
      .field("rounds", [Round]?.self),
      .field("teams", [Team]?.self),
      .field("drops", [Drop]?.self),
      .field("podPairingType", GraphQLEnum<Gamestateschema.PodPairingTypeV2>?.self),
      .field("gamesToWin", Int?.self),
    ] }

    var eventId: Gamestateschema.ID { __data["eventId"] }
    /// The minimum number of rounds required to reach a winner.
    var minRounds: Int? { __data["minRounds"] }
    /// The data for the drafting phase of the event. Only applicable for a draft formats (e.g., `WOTC_DRAFT`).
    var draft: Draft? { __data["draft"] }
    /// The list of draft pod assignments for the event after the cut to top 8. Fairly
    /// redundant, since this will always match the top 8 ranked players (there is only
    /// one pod). Only applicable for a draft formats (e.g., `WOTC_DRAFT`).
    var top8Draft: Top8Draft? { __data["top8Draft"] }
    /// The table seat assignments for players in a sealed constructed event.
    var deckConstruction: DeckConstruction? { __data["deckConstruction"] }
    /// The number of the current round. Will be 0 before the first round starts.
    var currentRoundNumber: Int { __data["currentRoundNumber"] }
    /// The list of rounds for this event. May be empty if no rounds have been created.
    var rounds: [Round]? { __data["rounds"] }
    /// Dictionary entries for the event teams. Key is a number value that matches the team id, value is the team object itself.
    var teams: [Team]? { __data["teams"] }
    /// A list of the teams who have dropped out of the event.
    var drops: [Drop]? { __data["drops"] }
    /// The pairing type that will determine the way to handle pairings with regards to pods
    var podPairingType: GraphQLEnum<Gamestateschema.PodPairingTypeV2>? { __data["podPairingType"] }
    /// The number of games until a win.
    var gamesToWin: Int? { __data["gamesToWin"] }

    /// Draft
    ///
    /// Parent Type: `DraftV2`
    struct Draft: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.DraftV2 }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(DraftPod.self),
      ] }

      /// The list of draft pod assignments for the event. Only applicable for a draft formats
      /// (e.g., `WOTC_DRAFT`).
      var pods: [Pod] { __data["pods"] }
      /// GUID or UUID of that represents Timer ID of Timer GraphQL for Drafting
      var timerId: Gamestateschema.ID? { __data["timerId"] }

      struct Fragments: FragmentContainer {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        var draftPod: DraftPod { _toFragment() }
      }

      /// Draft.Pod
      ///
      /// Parent Type: `PodV2`
      struct Pod: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.PodV2 }

        /// The pod number, a simple 1-based index. Not expected to correspond directly to
        /// any particular real-world table number.
        var podNumber: Int { __data["podNumber"] }
        /// The list of seat assignments for the pod.
        var seats: [Seat] { __data["seats"] }

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var podDetailsV2: PodDetailsV2 { _toFragment() }
        }

        /// Draft.Pod.Seat
        ///
        /// Parent Type: `SeatV2`
        struct Seat: Gamestateschema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.SeatV2 }

          /// The seat number, a simple 1-based index. Not expected to correspond directly to
          /// any particular real-world seat number.
          var seatNumber: Int { __data["seatNumber"] }
          /// Id of the team associated with the seat
          var teamId: Gamestateschema.ID { __data["teamId"] }

          struct Fragments: FragmentContainer {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            var seatDetailsV2: SeatDetailsV2 { _toFragment() }
          }
        }
      }
    }

    /// Top8Draft
    ///
    /// Parent Type: `DraftV2`
    struct Top8Draft: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.DraftV2 }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(DraftPod.self),
      ] }

      /// The list of draft pod assignments for the event. Only applicable for a draft formats
      /// (e.g., `WOTC_DRAFT`).
      var pods: [Pod] { __data["pods"] }
      /// GUID or UUID of that represents Timer ID of Timer GraphQL for Drafting
      var timerId: Gamestateschema.ID? { __data["timerId"] }

      struct Fragments: FragmentContainer {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        var draftPod: DraftPod { _toFragment() }
      }

      /// Top8Draft.Pod
      ///
      /// Parent Type: `PodV2`
      struct Pod: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.PodV2 }

        /// The pod number, a simple 1-based index. Not expected to correspond directly to
        /// any particular real-world table number.
        var podNumber: Int { __data["podNumber"] }
        /// The list of seat assignments for the pod.
        var seats: [Seat] { __data["seats"] }

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var podDetailsV2: PodDetailsV2 { _toFragment() }
        }

        /// Top8Draft.Pod.Seat
        ///
        /// Parent Type: `SeatV2`
        struct Seat: Gamestateschema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.SeatV2 }

          /// The seat number, a simple 1-based index. Not expected to correspond directly to
          /// any particular real-world seat number.
          var seatNumber: Int { __data["seatNumber"] }
          /// Id of the team associated with the seat
          var teamId: Gamestateschema.ID { __data["teamId"] }

          struct Fragments: FragmentContainer {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            var seatDetailsV2: SeatDetailsV2 { _toFragment() }
          }
        }
      }
    }

    /// DeckConstruction
    ///
    /// Parent Type: `DeckConstructionV2`
    struct DeckConstruction: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.DeckConstructionV2 }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(DeckConstructionDetails.self),
      ] }

      /// GUID or UUID of that represents Timer ID of Timer GraphQL for Deck Construction
      var timerId: Gamestateschema.ID? { __data["timerId"] }
      /// The list of seat assignments for the phase.
      var seats: [Seat] { __data["seats"] }

      struct Fragments: FragmentContainer {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        var deckConstructionDetails: DeckConstructionDetails { _toFragment() }
      }

      /// DeckConstruction.Seat
      ///
      /// Parent Type: `SeatV2`
      struct Seat: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.SeatV2 }

        /// The seat number, a simple 1-based index. Not expected to correspond directly to
        /// any particular real-world seat number.
        var seatNumber: Int { __data["seatNumber"] }
        /// Id of the team associated with the seat
        var teamId: Gamestateschema.ID { __data["teamId"] }

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var seatDetailsV2: SeatDetailsV2 { _toFragment() }
        }
      }
    }

    /// Round
    ///
    /// Parent Type: `RoundV2`
    struct Round: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.RoundV2 }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(RoundDetailsV2.self),
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

      struct Fragments: FragmentContainer {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        var roundDetailsV2: RoundDetailsV2 { _toFragment() }
      }

      /// Round.Match
      ///
      /// Parent Type: `MatchV2`
      struct Match: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.MatchV2 }

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

        /// Round.Match.Result
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

      /// Round.Standing
      ///
      /// Parent Type: `TeamStandingV2`
      struct Standing: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.TeamStandingV2 }

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

    /// Team
    ///
    /// Parent Type: `TeamV2`
    struct Team: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.TeamV2 }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(TeamDetailsV2.self),
      ] }

      /// The ID of the team.
      var teamId: Gamestateschema.ID { __data["teamId"] }
      /// The name of the team.
      var teamName: String? { __data["teamName"] }
      /// The players who make up the team.
      var players: [Player] { __data["players"] }

      struct Fragments: FragmentContainer {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        var teamDetailsV2: TeamDetailsV2 { _toFragment() }
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
    }

    /// Drop
    ///
    /// Parent Type: `DropV2`
    struct Drop: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.DropV2 }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(DropDetailsV2.self),
      ] }

      /// The ID of the team that dropped.
      var teamId: Gamestateschema.ID { __data["teamId"] }
      /// The last round number that the team participated in. Will be 0 if the team dropped
      /// before pairing for the first round.
      var roundNumber: Int { __data["roundNumber"] }

      struct Fragments: FragmentContainer {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        var dropDetailsV2: DropDetailsV2 { _toFragment() }
      }
    }
  }

}