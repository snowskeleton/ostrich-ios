// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension Gamestateschema {
  /// The input type to be used when creating a Private event.
  struct CreatePrivateEventInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      title: String,
      description: GraphQLNullable<String> = nil,
      eventFormatId: GraphQLNullable<ID> = nil,
      pairingType: GraphQLEnum<PairingType>,
      gamesToWin: Int,
      scheduledStartDateTime: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "title": title,
        "description": description,
        "eventFormatId": eventFormatId,
        "pairingType": pairingType,
        "gamesToWin": gamesToWin,
        "scheduledStartDateTime": scheduledStartDateTime
      ])
    }

    /// The title of the event. Required.
    var title: String {
      get { __data["title"] }
      set { __data["title"] = newValue }
    }

    /// A description of the event. Should not contain HTML. Optional
    var description: GraphQLNullable<String> {
      get { __data["description"] }
      set { __data["description"] = newValue }
    }

    /// The ID of the EventFormat for the event. Optional but will be required in the future.
    var eventFormatId: GraphQLNullable<ID> {
      get { __data["eventFormatId"] }
      set { __data["eventFormatId"] = newValue }
    }

    /// The pairing method for the event. Required.
    var pairingType: GraphQLEnum<PairingType> {
      get { __data["pairingType"] }
      set { __data["pairingType"] = newValue }
    }

    /// The number of games until a win. Required
    var gamesToWin: Int {
      get { __data["gamesToWin"] }
      set { __data["gamesToWin"] = newValue }
    }

    /// The Date & time that the event is scheduled to start, in ISO format. Optional
    var scheduledStartDateTime: GraphQLNullable<String> {
      get { __data["scheduledStartDateTime"] }
      set { __data["scheduledStartDateTime"] = newValue }
    }
  }

}