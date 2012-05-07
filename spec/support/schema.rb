ActiveRecord::Schema.define do
  self.verbose = false

  create_table :events, :force => true do |t|
    t.string :gid
    t.string :kind
    t.string :etag
    t.string :status
    t.string :htmlLink
    t.datetime :created
    t.datetime :updated
    t.string :summary
    t.string :description
    t.string :location
    t.string :colorId
    t.string :creator
    #{
    #  "email": string,
    #  "displayName": string
    #},
    t.string :organizer
    #{
    #  "email": string,
    #  "displayName": string
    #},
    t.string :start
    #{
    #  "date": date,
    #  "dateTime": datetime,
    #  "timeZone": string
    #},
    t.string :end
    #{
    #  "date": date,
    #  "dateTime": datetime,
    #  "timeZone": string
    #},
    t.string :recurrence
    #[
    #  string
    #],
    t.string :recurringEventId
    t.string :originalStartTime
    #{
    #  "date": date,
    #  "dateTime": datetime,
    #  "timeZone": string
    #},
    t.string :transparency
    t.string :visibility
    t.string :iCalUID
    t.integer :sequence
    t.string :attendees
    #[
    #  {
    #    "email": string,
    #    "displayName": string,
    #    "organizer": boolean,
    #    "self": boolean,
    #    "resource": boolean,
    #    "optional": boolean,
    #    "responseStatus": string,
    #    "comment": string,
    #    "additionalGuests": integer
    #  }
    #],
    t.boolean :attendeesOmitted
    t.string :extendedProperties
    #{
    #  "private": {
    #    (key): string
    #  },
    # "shared" : {
    #    (key): string
    #  }
    #}
    t.string :gadget
    #{
    #  "type": string,
    #  "title": string,
    #  "link": string,
    #  "iconLink": string,
    #  "width": integer,
    #  "height": integer,
    #  "display": string,
    #  "preferences": {
    #    (key): string
    # }
    #},
    t.boolean :anyoneCanAddSelf
    t.boolean :guestsCanInviteOthers
    t.boolean :guestsCanModify
    t.boolean :guestsCanSeeOtherGuests
    t.boolean :privateCopy
    t.string :reminders
    #
    #  "useDefault": boolean,
    #  "overrides": [
    #    {
    #      "method": string,
    #      "minutes": integer
    #    }
    #  ]
    #}
    
  end
end