//
//  LoadAction.swift
//  NewsFlash
//
//  Created by Michael Hulet on 3/9/25.
//

import SwiftUI

struct LoadAction {
    let action: () -> Void
    
    func callAsFunction() {
        action()
    }
}

extension EnvironmentValues {
    @Entry var loadAction = LoadAction { }
}
