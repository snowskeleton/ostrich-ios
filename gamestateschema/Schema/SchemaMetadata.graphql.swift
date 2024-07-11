// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

protocol Gamestateschema_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == Gamestateschema.SchemaMetadata {}

protocol Gamestateschema_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == Gamestateschema.SchemaMetadata {}

protocol Gamestateschema_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == Gamestateschema.SchemaMetadata {}

protocol Gamestateschema_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == Gamestateschema.SchemaMetadata {}

extension Gamestateschema {
  typealias SelectionSet = Gamestateschema_SelectionSet

  typealias InlineFragment = Gamestateschema_InlineFragment

  typealias MutableSelectionSet = Gamestateschema_MutableSelectionSet

  typealias MutableInlineFragment = Gamestateschema_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      switch typename {
      case "Query": return Gamestateschema.Objects.Query
      case "Event": return Gamestateschema.Objects.Event
      case "EventFormat": return Gamestateschema.Objects.EventFormat
      case "TeamPayload": return Gamestateschema.Objects.TeamPayload
      case "Registration": return Gamestateschema.Objects.Registration
      case "GameStateV2": return Gamestateschema.Objects.GameStateV2
      case "DraftV2": return Gamestateschema.Objects.DraftV2
      case "PodV2": return Gamestateschema.Objects.PodV2
      case "SeatV2": return Gamestateschema.Objects.SeatV2
      case "DeckConstructionV2": return Gamestateschema.Objects.DeckConstructionV2
      case "RoundV2": return Gamestateschema.Objects.RoundV2
      case "MatchV2": return Gamestateschema.Objects.MatchV2
      case "TeamResultV2": return Gamestateschema.Objects.TeamResultV2
      case "TeamStandingV2": return Gamestateschema.Objects.TeamStandingV2
      case "TeamV2": return Gamestateschema.Objects.TeamV2
      case "User": return Gamestateschema.Objects.User
      case "DropV2": return Gamestateschema.Objects.DropV2
      case "Mutation": return Gamestateschema.Objects.Mutation
      case "Subscription": return Gamestateschema.Objects.Subscription
      case "Timer": return Gamestateschema.Objects.Timer
      case "PrivateEvent": return Gamestateschema.Objects.PrivateEvent
      case "PlayerRegisteredPayload": return Gamestateschema.Objects.PlayerRegisteredPayload
      case "GamekeeperResultsNotificationPayload": return Gamestateschema.Objects.GamekeeperResultsNotificationPayload
      case "EventPage": return Gamestateschema.Objects.EventPage
      case "PageInfo": return Gamestateschema.Objects.PageInfo
      case "Organization": return Gamestateschema.Objects.Organization
      case "Money": return Gamestateschema.Objects.Money
      case "StorePage": return Gamestateschema.Objects.StorePage
      case "Queue": return Gamestateschema.Objects.Queue
      case "MatchFoundPayload": return Gamestateschema.Objects.MatchFoundPayload
      case "Seat": return Gamestateschema.Objects.Seat
      case "Team": return Gamestateschema.Objects.Team
      case "TeamResult": return Gamestateschema.Objects.TeamResult
      case "Match": return Gamestateschema.Objects.Match
      case "Round": return Gamestateschema.Objects.Round
      case "TeamStanding": return Gamestateschema.Objects.TeamStanding
      case "Drop": return Gamestateschema.Objects.Drop
      case "Pod": return Gamestateschema.Objects.Pod
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}