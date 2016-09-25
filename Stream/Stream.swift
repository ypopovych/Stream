//===--- Stream.swift ----------------------------------------------===//
//Copyright (c) 2016 Crossroad Labs s.r.o.
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.
//===----------------------------------------------------------------------===//

import Event
import Future

public enum StreamCloseEvent : Event {
    public typealias Payload = Void
    case event
}

public struct StreamEventGroup<E : Event> {
    internal let event:E
    
    private init(_ event:E) {
        self.event = event
    }
    
    public static var close:StreamEventGroup<StreamCloseEvent> {
        return StreamEventGroup<StreamCloseEvent>(.event)
    }
}

public protocol StreamEventEmitterProtocol : EventEmitter {
}

public extension StreamEventEmitterProtocol {
    func on<E : Event>(_ groupedEvent: StreamEventGroup<E>) -> EventConveyor<E.Payload> {
        return self.on(groupedEvent.event)
    }
    
    func once<E : Event>(_ groupedEvent: StreamEventGroup<E>, failOnError:@escaping (Error)->Bool = {_ in true}) -> Future<E.Payload> {
        return self.once(groupedEvent.event, failOnError: failOnError)
    }
    
    func emit<E : Event>(_ groupedEvent: StreamEventGroup<E>, payload:E.Payload) {
        self.emit(groupedEvent.event, payload: payload)
    }
}

public enum StreamError : Error {
    case invalidUnpipe
}
