//
//  TextFieldElement+AddressFactory.swift
//  StripeUICore
//
//  Created by Yuki Tokuhiro on 6/8/21.
//  Copyright © 2021 Stripe, Inc. All rights reserved.
//

import Foundation
import UIKit
@_spi(STP) import StripeCore

@_spi(STP) public extension TextFieldElement {

    // MARK: - Address
    
    enum Address {
        
        // MARK: - Name
        
        struct NameConfiguration: TextFieldElementConfiguration {
            let label = String.Localized.name
            let defaultValue: String?

            init(defaultValue: String?) {
                self.defaultValue = defaultValue
            }

            func keyboardProperties(for text: String) -> TextFieldElement.KeyboardProperties {
                return .init(type: .namePhonePad, textContentType: .name, autocapitalization: .words)
            }
        }
        
        public static func makeName(defaultValue: String?) -> TextFieldElement {
            return TextFieldElement(configuration: NameConfiguration(defaultValue: defaultValue))
        }
        
        // MARK: - Email
        
        struct EmailConfiguration: TextFieldElementConfiguration {
            let label = String.Localized.email
            let defaultValue: String?
            let disallowedCharacters: CharacterSet = .whitespacesAndNewlines
            let invalidError = Error.invalid(
                localizedDescription: String.Localized.invalid_email
            )

            init(defaultValue: String?) {
                self.defaultValue = defaultValue
            }

            func validate(text: String, isOptional: Bool) -> ValidationState {
                if text.isEmpty {
                    return isOptional ? .valid : .invalid(Error.empty)
                }
                if STPEmailAddressValidator.stringIsValidEmailAddress(text) {
                    return .valid
                } else {
                    return .invalid(invalidError)
                }
            }

            func keyboardProperties(for text: String) -> TextFieldElement.KeyboardProperties {
                return .init(type: .emailAddress, textContentType: .emailAddress, autocapitalization: .none)
            }
        }
        
        public static func makeEmail(defaultValue: String?) -> TextFieldElement {
            return TextFieldElement(configuration: EmailConfiguration(defaultValue: defaultValue))
        }
        
        // MARK: - Line1, Line2
        
        struct LineConfiguration: TextFieldElementConfiguration {
            enum LineType {
                case line1
                case line2
            }
            let lineType: LineType
            var label: String {
                switch lineType {
                case .line1:
                    return String.Localized.address_line1
                case .line2:
                    return String.Localized.address_line2
                }
            }
            let defaultValue: String?

            init(lineType: LineType, defaultValue: String?) {
                self.lineType = lineType
                self.defaultValue = defaultValue
            }

        }
        
        static func makeLine1(defaultValue: String?) -> TextFieldElement {
            return TextFieldElement(
                configuration: LineConfiguration(lineType: .line1, defaultValue: defaultValue)
            )
        }
        
        static func makeLine2(defaultValue: String?) -> TextFieldElement {
            let line2 = TextFieldElement(
                configuration: LineConfiguration(lineType: .line2, defaultValue: defaultValue)
            )
            line2.isOptional = true // Hardcode all line2 as optional
            return line2
        }
        
        // MARK: - City/Locality
        
        struct CityConfiguration: TextFieldElementConfiguration {
            let label: String
            let defaultValue: String?

            init(label: String, defaultValue: String?) {
                self.label = label
                self.defaultValue = defaultValue
            }

            func keyboardProperties(for text: String) -> TextFieldElement.KeyboardProperties {
                return .init(type: .default, textContentType: .addressCity, autocapitalization: .words)
            }
        }
        
        // MARK: - State/Province/Administrative area/etc.
        
        struct StateConfiguration: TextFieldElementConfiguration {
            let label: String
            let defaultValue: String?

            init(label: String, defaultValue: String?) {
                self.label = label
                self.defaultValue = defaultValue
            }

            func keyboardProperties(for text: String) -> TextFieldElement.KeyboardProperties {
                return .init(type: .default, textContentType: .addressState, autocapitalization: .words)
            }
        }
        
        // MARK: - Postal code/Zip code
        
        struct PostalCodeConfiguration: TextFieldElementConfiguration {
            let regex: String?
            let label: String
            let defaultValue: String?

            init(regex: String?, label: String, defaultValue: String?) {
                self.regex = regex
                self.label = label
                self.defaultValue = defaultValue
            }

            func validate(text: String, isOptional: Bool) -> ValidationState {
                if text.isEmpty {
                    return isOptional ? .valid : .invalid(Error.empty)
                }
                if regex != nil {
                   // verify
                }
                return .valid
            }
            
            func keyboardProperties(for text: String) -> TextFieldElement.KeyboardProperties {
                return .init(type: .default, textContentType: .postalCode, autocapitalization: .allCharacters)
            }
        }
    }
}