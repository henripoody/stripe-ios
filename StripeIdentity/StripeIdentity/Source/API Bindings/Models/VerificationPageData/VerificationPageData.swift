//
//  VerificationPageData.swift
//  StripeIdentity
//
//  Created by Mel Ludowise on 11/2/21.
//

import Foundation
@_spi(STP) import StripeCore

/// VerificationPageData contains the state of a verification, including what information
/// needs to be collected to complete the verification flow.
struct VerificationPageData: StripeDecodable, Equatable {
    typealias Status = VerificationPage.Status

    let id: String
    /// Status of the associated VerificationSession.
    let status: Status
    /// If true, the associated VerificationSession has been submitted for processing.
    let submitted: Bool
    /// Contains the fields that need to be collected and any errors associated with them.
    let requirements: VerificationPageDataRequirements

    var _allResponseFieldsStorage: NonEncodableParameters?
}
