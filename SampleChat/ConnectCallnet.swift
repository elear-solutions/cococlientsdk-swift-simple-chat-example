//
//  ConnectCallnet.swift
//  SampleChat
//
//  Created by rohan-elear on 17/01/21.
//

import SwiftUI

struct ConnectCallnet: View {
  let storage = LocalStorageService.init()
  var chatController: ChatController = ChatController()
  
  @State var networkId: String = ""
  @State var inviteURL: String = ""
  @State var nodeId: String = ""
  @State var username: String = ""
  @State var isLinkActive = false
  
  var body: some View {
    NavigationView {
      VStack {
        TextField("Network ID", text: $networkId)
          .frame(width: CGFloat(300), height: CGFloat(30), alignment: .center)
          .padding()
          .cornerRadius(30)
        
        TextField("Invite URL", text: $inviteURL)
            .frame(width: CGFloat(300), height: CGFloat(30), alignment: .center)
            .padding()
            .cornerRadius(30)
        
        TextField("Node ID", text: $nodeId)
          .frame(width: CGFloat(300), height: CGFloat(30), alignment: .center)
          .padding()
          .cornerRadius(30)
          .keyboardType(.numberPad)
        
        TextField("Username", text: $username)
          .frame(width: CGFloat(300), height: CGFloat(30), alignment: .center)
          .padding()
          .cornerRadius(30)
        
        Button(action: connectCallnet) {
          Text("Connect Callnet")
        }
        .frame(width: CGFloat(150), height: CGFloat(30), alignment: .center)
        .padding(8)
        .cornerRadius(40)
        .foregroundColor(.white)
        .background(Color.blue)
      }
      .onAppear(perform: {
        networkId = storage.restoreNetworkId()
        nodeId = String(storage.restoreNodeId())
        username = String(storage.restoreUsername())
      })
      .background(
        NavigationLink(
          destination: ContentView()
            .environmentObject(chatController),
          isActive: $isLinkActive,
          label: {
            Text("Navigate")
          })
          .hidden()
      )
    }
    .navigationTitle("SampleChat")
  }
  
  init() {
    if !storage.restoreNetworkId().isEmpty {
      isLinkActive = true
    }
  }
  
  func connectCallnet() {
    chatController.client.networkId = networkId
    chatController.client.inviteURL = inviteURL
    chatController.client.nodeId = UInt32(nodeId) ?? 0
    storage.storeUsername(username)
    
    isLinkActive = true
  }
}
#if DEBUG
struct ConnectCallnet_Previews: PreviewProvider {
  static var previews: some View {
    ConnectCallnet()
  }
}
#endif
