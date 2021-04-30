//
//  DurationEvent.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 9/16/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation

/// An event that begins at a date, ends at an optional date, and has a duration.
protocol RelativeTimeEvent {

    /// The event start offset in seconds within the containing time window.
    var started: Float { get }

    /// Duration of the event, or 0 if not applicable.
    /// 0 may be interpreted as "until the next event of the same type".
    var duration: Float { get }
}

extension RelativeTimeEvent {

    /// The event stop offset in seconds within the containing time window.
    var stopped: Float {
        return started + duration
    }
}

/// An event that begins at a date, ends at an optional date, and has a duration.
protocol AbsoluteTimeEvent {

    /// The date the event began.
    var started: Date { get }

    /// The date the event ended, or nil if it is still in effect.
    var stopped: Date? { get }
}

extension AbsoluteTimeEvent {

    /// Duration of the event, or 0 if not applicable.
    /// 0 may be interpreted as "until the next event of the same type".
    var duration: TimeInterval {
        max(0, stopped?.timeIntervalSince(started) ?? 0)
    }

    /// Retrieve a dictionary representation of the object.
//    var dictionaryRepresentation: [AnyHashable: Any] {
//        Mirror(reflecting: self).children
//            .reduce(into: [AnyHashable: Any]()) { (result, tuplet) in
//                if tuplet.label != nil, Mirror.init(reflecting: tuplet.value).displayStyle != .enum {
//                    result[tuplet.label] = tuplet.value
//                }
//            }
//    }
}

struct ValueRelativeTimeEvent: RelativeTimeEvent {
    let started: Float
    let duration: Float
    let value: Float
}

protocol GraphableRelativeTimeEvent: RelativeTimeEvent {
    var yValue: Float { get }
}
