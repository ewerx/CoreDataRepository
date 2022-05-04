// CRUDRepositoryFailure.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2022 Andrew Roan

import CoreData
import Foundation

/// Error type for CRUD functions of `CoreDataRepository`
public struct CRUDRepositoryFailure: Error {
    public let code: FailureCode
    public let method: Method
    public let url: URL?

    public init(
        code: FailureCode,
        method: Method,
        url: URL?
    ) {
        self.code = code
        self.method = method
        self.url = url
    }

    /// Function or Endpoing where the error originated
    public enum Method: Int {
        case create = 10
        case read = 20
        case update = 30
        case delete = 40

        var localizedDescription: String {
            switch self {
            case .create:
                return NSLocalizedString(
                    "create",
                    bundle: .module,
                    comment: "Name for a batch create failure method."
                )
            case .read:
                return NSLocalizedString(
                    "read",
                    bundle: .module,
                    comment: "Name for a batch read failure method."
                )
            case .update:
                return NSLocalizedString(
                    "update",
                    bundle: .module,
                    comment: "Name for a batch update failure method."
                )
            case .delete:
                return NSLocalizedString(
                    "delete",
                    bundle: .module,
                    comment: "Name for a batch delete failure method."
                )
            }
        }
    }

    public var localizedDescription: String {
        String(
            format: NSLocalizedString(
                "Encountered the following error while executing a %@: %@",
                bundle: .module,
                comment: "Description of a CRUD operation error."
            ),
            "\(method.localizedDescription)",
            "\(code.localizedDescription)"
        )
    }
}

// MARK: CustomNSError Conformance

extension CRUDRepositoryFailure: CustomNSError {
    public static let errorDomain: String = "CoreDataRepository-CRUDRepository"

    public var errorCode: Int {
        code.rawValue + method.rawValue
    }
}

// MARK: Hashable conformance

extension CRUDRepositoryFailure: Hashable {}
