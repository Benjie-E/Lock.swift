// OfflineConnections.swift
//
// Copyright (c) 2016 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

struct OfflineConnections: ConnectionBuildable {

    var database: DatabaseConnection?
    var oauth2: [OAuth2Connection]
    let allowedConnections: [String]

    init(database: DatabaseConnection? = nil, oauth2: [OAuth2Connection] = [], allowedConnections: [String] = []) {
        self.database = database
        self.oauth2 = oauth2
        self.allowedConnections = allowedConnections
    }

    mutating func database(name name: String, requiresUsername: Bool) {
        guard isAllowed(connectionName: name) else { return }
        self.database = DatabaseConnection(name: name, requiresUsername: requiresUsername)
    }

    mutating func social(name name: String, style: AuthStyle) {
        self.oauth2(name: name, style: style)
    }

    mutating func oauth2(name name: String, style: AuthStyle) {
        guard isAllowed(connectionName: name) else { return }
        let social = SocialConnection(name: name, style: style)
        self.oauth2.append(social)
    }

    var isEmpty: Bool {
        return self.database == nil && self.oauth2.isEmpty
    }

    private func isAllowed(connectionName name: String) -> Bool {
        return self.allowedConnections.isEmpty || !self.allowedConnections.contains(name)
    }
}