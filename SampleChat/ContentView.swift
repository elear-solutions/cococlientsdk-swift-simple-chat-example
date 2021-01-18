//
//  ContentView.swift
//  SampleChat
//
//  Created by rohan-elear on 16/01/21.
//

import SwiftUI
import CocoClientSDK

struct ChatRow: View {
  var msg: ChatMessage
  var body: some View {
    if msg.isMe {
      HStack {
        Spacer()
        Group {
          Text(msg.message!)
            .foregroundColor(Color.white)
            .padding(8)
            .background(Color.green)
            .cornerRadius(10)
          Text(msg.avatar!)
        }
      }
    } else {
      HStack {
        Group {
          Text(msg.avatar!)
          Text(msg.message!)
            .foregroundColor(Color.white)
            .padding(8)
            .background(Color.blue)
            .cornerRadius(10)
        }
      }
      .alignmentGuide(.trailing,
                      computeValue: { dimension in
        dimension[.trailing]
      })
    }
  }
}

struct ContentView: View {
  // @State here is necessary to make the composedMessage variable accessible
  // from different views
  @State var composedMessage: String = ""
  @EnvironmentObject var chatController: ChatController
  
  var body: some View {
    VStack {
      List {
        ForEach(chatController.messages, id: \.self) { msg in
          ChatRow(msg: msg)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
      .listRowInsets(EdgeInsets(top: -1, leading: -1, bottom: -1, trailing: -1))
      .background(Color(.systemBackground))
      
      HStack {
        TextField("Message...", text: $composedMessage).frame(minHeight: CGFloat(30))
        Button(action: sendMessage) {
          Text("Send")
        }
      }.frame(minHeight: CGFloat(50)).padding()
    }
    .padding()
    .onAppear(perform: {
      let storage = LocalStorageService.init()
      let savedNetworkId = storage.restoreNetworkId()
      if savedNetworkId.isEmpty {
        let params = ConnectParams()
        params.setNetworkName(chatController.client.networkName)
        params.setNetworkType(chatController.client.networkType)
        params.setUserRole(chatController.client.userRole)
        params.setAccessType(chatController.client.accessType)
        do {
          _ = try CocoClientSDK.Network.connect(with: params,
                                                networkId: chatController.client.networkId,
                                                nodeId: chatController.client.nodeId,
                                                inviteURL: chatController.client.inviteURL)
          storage.storeNetworkId(chatController.client.networkId)
          storage.saveNodeId(chatController.client.nodeId)
        } catch {
          fatalError("Unable to connect to callnet")
        }
      } else {
        guard ((try? chatController.client.coco?.get_saved_networks()) != nil) else {
          fatalError("No saved networks")
        }
        guard ((try? chatController.client.coco?.networkMap[savedNetworkId]?.connect()) != nil) else {
          fatalError("No network with savedNetworkId")
        }
      }
    })
  }
  
  func sendMessage() {
    let message = ChatMessage(message: composedMessage,
                              avatar: String(LocalStorageService.init().restoreNodeId()),
                              isMe: true)
    try? chatController.sendMessage(message)
    composedMessage = ""
  }
  
  #if DEBUG
  struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
      ContentView()
        .environmentObject(ChatController())
    }
  }
  #endif
}
