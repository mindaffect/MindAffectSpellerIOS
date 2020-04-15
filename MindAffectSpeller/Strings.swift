// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// I want to say something.
  internal static let defaultSentence1 = L10n.tr("Localizable", "DefaultSentence1")
  /// I would like a drink.
  internal static let defaultSentence2 = L10n.tr("Localizable", "defaultSentence2")
  /// I am not sitting comfortably.
  internal static let defaultSentence3 = L10n.tr("Localizable", "defaultSentence3")
  /// No
  internal static let no = L10n.tr("Localizable", "no")
  /// Sentence
  internal static let sentence = L10n.tr("Localizable", "sentence")
  /// Temporary test
  internal static let tempTest = L10n.tr("Localizable", "Temp-test")
  /// bla e
  internal static let test = L10n.tr("Localizable", "test")
  /// Yes
  internal static let yes = L10n.tr("Localizable", "yes")

  internal enum Homescreen {
    /// Start screen
    internal static let title = L10n.tr("Localizable", "homescreen.title")
  }

  internal enum Settings {
    internal enum Pages {
      /// Keyboard
      internal static let keyboard = L10n.tr("Localizable", "settings.pages.keyboard")
      /// Sound
      internal static let sound = L10n.tr("Localizable", "settings.pages.sound")
      /// Start screen
      internal static let startScreen = L10n.tr("Localizable", "settings.pages.start-screen")
      internal enum BrainPresses {
        /// Brain presses
        internal static let title = L10n.tr("Localizable", "settings.pages.brain-presses.title")
      }
      internal enum Startscreen {
        /// Choose between variants of the Start Screen. Edit sentences 1-3
        internal static let subtitle = L10n.tr("Localizable", "settings.pages.startscreen.subtitle")
      }
      internal enum Startscreen1 {
        /// Start screen (1)
        internal static let title = L10n.tr("Localizable", "settings.pages.startscreen1.title")
      }
      internal enum Startscreen2 {
        /// Edit the Start Screen sentences 4-9.
        internal static let subtitle = L10n.tr("Localizable", "settings.pages.startscreen2.subtitle")
        /// Start screen (2)
        internal static let title = L10n.tr("Localizable", "settings.pages.startscreen2.title")
      }
    }
  }

  internal enum SettingsScreen {
    /// Settings
    internal static let title = L10n.tr("Localizable", "settings-screen.title")
  }

  internal enum SleepScreen {
    internal enum Explanation {
      /// Double tap to switch to the Alarm button.
      internal static let ifAlarmOff = L10n.tr("Localizable", "sleep-screen.explanation.if-alarm-off")
      /// Double tap again to go back to the Start screen.
      internal static let ifAlarmOn = L10n.tr("Localizable", "sleep-screen.explanation.if-alarm-on")
    }
  }

  internal enum StartScreen {
    internal enum Sentences {
      /// 9 sentences instead of 3 + Yes and No
      internal static let variant = L10n.tr("Localizable", "start-screen.sentences.variant")
    }
  }

  internal enum YesNo {
    /// No
    internal static let no = L10n.tr("Localizable", "yes-no.no")
    /// Yes
    internal static let yes = L10n.tr("Localizable", "yes-no.yes")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
