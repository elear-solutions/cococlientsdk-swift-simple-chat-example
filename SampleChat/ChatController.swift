//
//  ChatController.swift
//  SampleChat
//
//  Created by rohan-elear on 16/01/21.
//

import Combine
import SwiftUI
import CocoClientSDK

class ChatController : ObservableObject {
  var notificaton = NotificationCenter.default
  var client: Client = Client()
  init() {
    notificaton.addObserver(self,
                            selector: #selector(data_callback(notification:)),
                            name: NSNotification.Name(ClientSDK.NotificationKeys.dataCallback.rawValue),
                            object: nil)
  }
  
  // didChange will let the SwiftUI know that some changes have happened in this object
  // and we need to rebuild all the views related to that object
  var didChange = PassthroughSubject<Void, Never>()
  
  // We've relocated the messages from the main SwiftUI View. Now, if you wish, you can handle the networking part here and populate this array with any data from your database. If you do so, please share your code and let's build the first global open-source chat app in SwiftUI together
  // It has to be @Published in order for the new updated values to be accessible from the ContentView Controller
  @Published var messages = LocalStorageService.init().restoreChats()
  
  // this function will be accessible from SwiftUI main view
  // here you can add the necessary code to send your messages not only to the SwiftUI view, but also to the database so that other users of the app would be able to see it
  func sendMessage(_ chatMessage: ChatMessage) throws {
    // here we populate the messages array
    messages.append(chatMessage)
    let encoder = JSONEncoder()
    let data = (try? encoder.encode(chatMessage))!
    let payload = String(data: data, encoding: .utf8)
    let nodeIds = [UInt32]()
    do {
      try client.coco?.networkMap[client.networkId]?.sendData(with: payload,
                                                          nodeIds: nodeIds)
    } catch {
      fatalError("failed to send network")
    }
    
    // here we let the SwiftUI know that we need to rebuild the views
    didChange.send(())
    LocalStorageService.init().saveChats(messages)
  }
  
  func addMessage(_ data: Data) {
    let decoder = JSONDecoder()
    var message = try? decoder.decode(ChatMessage.self, from: data)
    message?.isMe = false
    messages.append(message ?? ChatMessage())
    didChange.send(())
    LocalStorageService.init().saveChats(messages)
  }
  
  @objc func data_callback(notification: NSNotification) {
    if let json = notification.userInfo?["data"] as? String {
      let data = json.data(using: .utf8)
      addMessage(data!)
    }
  }
}
