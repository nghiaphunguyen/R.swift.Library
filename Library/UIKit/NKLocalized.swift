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
  
  public static var languageCode: String? {
    get {
      return NSUserDefaults.standardUserDefaults().stringForKey(Constant.languageCodeKey)
    }
    
    set {
      NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: Constant.languageCodeKey)
      NSUserDefaults.standardUserDefaults().synchronize()
      
      NSNotificationCenter.defaultCenter().postNotificationName(kLocalizedChangedNotificationName, object: newValue)
    }
  }
  
  public static var bundle: NSBundle = NSBundle.mainBundle()
  
  public static func localized(string: String, table: String? = nil) -> String {
    if let languageCode = self.languageCode, path = self.bundle.pathForResource(languageCode, ofType: "lproj"), b = NSBundle(path: path) {
      return b.localizedStringForKey(string, value: nil, table: table)
    }
    
    return NSLocalizedString(string, tableName: table, bundle: self.bundle, value: "", comment: "")
  }
  
  public static func availableLanguages(excludeBase: Bool = true) -> [String] {
    var availableLanguages = self.bundle.localizations
    if let indexOfBase = availableLanguages.indexOf("Base") where excludeBase == true {
      availableLanguages.removeAtIndex(indexOfBase)
    }
    return availableLanguages
  }
}