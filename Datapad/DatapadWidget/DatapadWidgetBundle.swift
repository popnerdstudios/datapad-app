//
//  DatapadWidgetBundle.swift
//  DatapadWidget
//
//  Created by Sree Gajula on 3/30/23.
//

import WidgetKit
import SwiftUI

@main
struct DatapadWidgetBundle: WidgetBundle {
    var body: some Widget {
        DatapadWidget()
        DatapadWidgetLiveActivity()
    }
}
