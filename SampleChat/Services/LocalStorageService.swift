//
//  LocalStorageService.swift
//  SampleChat
//
//  Created by rohan-elear on 17/01/21.
//

import Foundation

class LocalStorageService {
  let userDefaults: UserDefaults
  
  enum dataKeys: String {
    case networkId
    case nodeId
    case chatHistory
    case username
  }
  
  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }
  
  private func save(forKey key: dataKeys, value: Any) {
    userDefaults.setValue(value, forKey: key.rawValue)
  }
  
  private func restore<T>(forKey key: dataKeys) -> T? {
    return userDefaults.value(forKey: key.rawValue) as? T
  }
  
  func storeNetworkId(_ networkId: String) {
    save(forKey: .networkId, value: networkId)
  }
  
  func restoreNetworkId() -> String {
    let networkId: String? = restore(forKey: .networkId)
    return networkId ?? ""
  }
  
  func saveChats(_ messages: [ChatMessage]) {
    let encoder = JSONEncoder()
    let encoded = try? encoder.encode(messages)
    let data = String(data: encoded!, encoding: .utf8)
    save(forKey: .chatHistory, value: data ?? "")
  }
  
  func restoreChats() -> [ChatMessage] {
    let decoder = JSONDecoder()
    let encoded: String? = restore(forKey: .chatHistory)
    let data = encoded?.data(using: .utf8)
    guard data != nil else {
      return [ChatMessage]()
    }
    let messages: [ChatMessage] = try! decoder.decode([ChatMessage].self,
                                                      from: data!)
    return messages
  }
  
  func saveNodeId(_ nodeId: UInt32) {
    save(forKey: .nodeId, value: nodeId)
  }
  
  func restoreNodeId() -> UInt32 {
    let nodeId: UInt32? = restore(forKey: .nodeId)
    return nodeId ?? 0
  }
  
  func storeUsername(_ username: String) {
    save(forKey: .username, value: username)
  }
  
  func restoreUsername() -> String {
    let username: String? = restore(forKey: .username)
    return username ?? ""
  }
}
