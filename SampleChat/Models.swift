//
//  Models.swift
//  SampleChat
//
//  Created by rohan-elear on 16/01/21.
//

import SwiftUI

struct ChatMessage: Hashable, Codable {
  var message: String?
  var avatar: String?
  var isMe: Bool = false
}


