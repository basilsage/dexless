//
//  Task.swift
//  Dexless
//
//  Created by DJ Satoda on 9/15/21.
//  Copyright © 2021 DJ Satoda. All rights reserved.
//

import Foundation

struct Task: Identifiable, Codable {
  var id = UUID().uuidString
  var name: String
  var completed = false
  var reminderEnabled = false
  var reminder: Reminder
}

enum ReminderType: Int, CaseIterable, Identifiable, Codable {
  case time
  case calendar
  case location
  var id: Int { self.rawValue }
}

struct Reminder: Codable {
  var timeInterval: TimeInterval?
  var date: Date?
  var location: LocationReminder?
  var reminderType: ReminderType = .time
  var repeats = false
}

struct LocationReminder: Codable {
  var latitude: Double
  var longitude: Double
  var radius: Double
}
