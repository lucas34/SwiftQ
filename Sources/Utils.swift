//
// Created by Lucas Nelaupe on 10/08/2017.
// Copyright (c) 2017 lucas34. All rights reserved.
//

import Foundation

func runInBackgroundAfter(_ seconds: TimeInterval, callback: @escaping () -> Void) {
    let delta = DispatchTime.now() + Double(Int64(seconds) * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).asyncAfter(deadline: delta, execute: callback)
}

func toJSON(_ obj: Any) -> String? {
    let json = try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
    return json.flatMap { NSString(data: $0, encoding: String.Encoding.utf8.rawValue) as String? }
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
