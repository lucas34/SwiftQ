//
// Created by Lucas Nelaupe on 10/08/2017.
// Copyright (c) 2017 lucas34. All rights reserved.
//

import Foundation

func runInBackgroundAfter(_ seconds: TimeInterval, callback: @escaping () -> Void) {
    let delta = DispatchTime.now() + seconds
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).asyncAfter(deadline: delta, execute: callback)
}

func toJSON(_ obj: [String: Any]) -> String? {
    assert(JSONSerialization.isValidJSONObject(obj))
    let jsonData = try? JSONSerialization.data(withJSONObject: obj)
    return jsonData.flatMap { String(data: $0, encoding: .utf8) }
}

func fromJSON(_ str: String) -> Any? {
    return str.data(using: String.Encoding.utf8, allowLossyConversion: false)
            .flatMap { try? JSONSerialization.jsonObject(with: $0, options: .allowFragments)  }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
    return formatter
}()
