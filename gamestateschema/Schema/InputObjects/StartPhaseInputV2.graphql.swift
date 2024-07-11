// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension Gamestateschema {
  struct StartPhaseInputV2: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      eventId: ID,
      timerId: GraphQLNullable<ID> = nil
    ) {
      __data = InputDict([
        "eventId": eventId,
        "timerId": timerId
      ])
    }

    /// The ID of the event.
    var eventId: ID {
      get { __data["eventId"] }
      set { __data["eventId"] = newValue }
    }

    /// The ID of first phase timer.
    var timerId: GraphQLNullable<ID> {
      get { __data["timerId"] }
      set { __data["timerId"] = newValue }
    }
  }

}