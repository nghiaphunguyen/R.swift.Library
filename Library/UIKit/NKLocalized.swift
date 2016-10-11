//
//  NKLocalized.swift
//  NKit
//
//  Created by Nghia Nguyen on 10/2/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation

public final class NKLocalized: AnyObject {
  public static let kLocalizedChangedNotificationName = "nkit_localied_changed_notification_name"
  
  private struct Constant {
    static var languageCodeKey: String {return "nkit_language_code_key"}
  }
  
  public static var currentLanguageCode: String? {
    get {
      return UserDefaults.standard.string(forKey: Constant.languageCodeKey)
    }
    
    set {
      UserDefaults.standard.set(newValue, forKey: Constant.languageCodeKey)
      UserDefaults.standard.synchronize()
      
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLocalizedChangedNotificationName), object: newValue)
    }
  }
  
  public static var bundle: Bundle = Bundle.main
  
  public static func localized(_ string: String, table: String? = nil) -> String {
    if let languageCode = self.currentLanguageCode, let path = self.bundle.path(forResource: languageCode, ofType: "lproj"), let b = Bundle(path: path) {
      
      let
      result = b.localizedString(forKey: string, value: nil, table: table)
      
      if result != string || languageCode == "en" {
        return result
      }
    }
    
    return NSLocalizedString(string, tableName: table, bundle: self.bundle, value: "", comment: "")
  }
  
  public static func availableLanguages(_ excludeBase: Bool = true) -> [String] {
    var availableLanguages = self.bundle.localizations
    if let indexOfBase = availableLanguages.index(of: "Base") , excludeBase == true {
      availableLanguages.remove(at: indexOfBase)
    }
    return availableLanguages
  }
}
