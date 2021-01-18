//
//  CocoClient.swift
//  SampleChat
//
//  Created by rohan-elear on 16/01/21.
//

import CocoClientSDK
import SwiftUI
import os

class Client {
  var inviteURL: String = ""
  var nodeId: UInt32 = 0
  var networkId: String = ""
  var networkName: String = "watch together 1"
  var networkType: Network.NetworkType = .COCO_CLIENT_COCONET_TYPE_CALL_NET
  var userRole: Network.UserRole = .USER_ROLE_OWNER
  var accessType: Network.AccessType = .ACCESS_TYPE_REMOTE
  
  public var coco: CocoClient?
  
  init() {
    do {
      let cocoClient = try CocoClient.get_instance(platform: PlatformCallback(),
                                                   cocoCallbackDelegate: ClientCallback(),
                                                   connectivityTimers: nil,
                                                   creator: nil)
      coco = cocoClient
    } catch {
      fatalError("Failed to initilize SDK")
    }
  }
}

class ClientSDK {
  
  enum NotificationKeys: String {
    case connectStatusCallback
    case contentInfoCallback
    case networkMetadataCallback
    case dataCallback
  }
  
}

class PlatformCallback: PlatformDelegate {
  func getCwdPath() -> String {
    return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
  }
  
  func getClientId() -> String {
    return "f58fcc023f5aa820c2b4"
  }
  
  func getAppAccesslist() -> String {
    let accessList = "{\"appCapabilities\": [0]}"
    return accessList
  }
  
  func OAuthCallback(authorizationEndpoint: String, tokenEndpoint: String) {
    return
  }
  
  func AccessTokenCallback(token: String?, status: StatusCode, context: UnsafeMutableRawPointer?) {
    return
  }
  
  func RefreshTokenCB(status: StatusCode) {
    return
  }
  
  func getDownloadPath() -> String {
    return getCwdPath()
  }
  
}

class ClientCallback: CocoCallbackDelegate {
  
  func ConnectStatusCallback(network: Network?, coconetStatus: Network.State, context: UnsafeMutableRawPointer?) {
    print("\(#function) started")
    let userInfo: [String: Any] = ["network": network as Any,
                                   "coconetStatus": coconetStatus,
                                   "context": context as Any]
    NotificationCenter.default.post(name: NSNotification.Name(ClientSDK.NotificationKeys.connectStatusCallback.rawValue), object: nil, userInfo: userInfo)
    print("\(#function) completed")
  }
  
  func ContentInfoCallback(metadata: String,
                           contentTime: Int32,
                           nodeId: UInt32,
                           coconetContext: UnsafeMutableRawPointer?) {
    print("\(#function) started")
    let userInfo: [String: Any] = ["metadata": metadata as Any,
                                   "contentTime": contentTime as Any,
                                   "nodeId": nodeId as Any,
                                   "coconetContext": coconetContext as Any]
    NotificationCenter.default.post(name: NSNotification.Name(ClientSDK.NotificationKeys.contentInfoCallback.rawValue), object: nil, userInfo: userInfo)
    print("\(#function) metadata: \(metadata)")
    print("\(#function) nodeId: \(nodeId)")
    print("\(#function) completed")
  }
  
  func NetworkMetadataCallback(metadata: String,
                               coconetContext: UnsafeMutableRawPointer?) {
    print("\(#function) started")
    let userInfo: [String: Any] = ["metadata": metadata as Any,
                                   "coconetContext": coconetContext as Any]
    NotificationCenter.default.post(name: NSNotification.Name(ClientSDK.NotificationKeys.networkMetadataCallback.rawValue), object: nil, userInfo: userInfo)
    print("\(#function) metadata: \(metadata)")
    print("\(#function) completed")
  }
  
  func DataCallback(data: String,
                    nodeId: UInt32,
                    coconetContext: UnsafeMutableRawPointer?) {
    print("\(#function) started")
    let userInfo: [String: Any] = ["data": data as Any,
                                   "nodeId": nodeId as Any,
                                   "coconetContext": coconetContext as Any]
    NotificationCenter.default.post(name: NSNotification.Name(ClientSDK.NotificationKeys.dataCallback.rawValue), object: nil, userInfo: userInfo)
    print("\(#function) nodeId: \(nodeId) data: \(data)")
    print("\(#function) completed")
  }
  
}
