// UnmanagedModel.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2023 Andrew Roan

import CoreData
import Foundation

/// A protocol for a value type that corresponds to a RepositoryManagedModel
public protocol UnmanagedModel: Equatable {
    associatedtype RepoManaged: RepositoryManagedModel where RepoManaged.Unmanaged == Self
    /// Keep an reference to the corresponding `RepositoryManagedModel` instance for getting it later.
    /// Optional since a new instance won't have a record in CoreData.
    var managedRepoUrl: URL? { get set }
    /// Returns a RepositoryManagedModel instance of `self`
    func asRepoManaged(in context: NSManagedObjectContext) -> RepoManaged
}

public extension UnmanagedModel {
    var isManaged: Bool {
        managedRepoUrl != nil
    }
  
    func getManagedObjectId(in context: NSManagedObjectContext) -> NSManagedObjectID? {
        guard let url = managedRepoUrl else { return nil }
        return try? context.tryObjectId(from: url)
    }
    
    /// Fetch the repo managed object from its url
    func getManagedObject(in context: NSManagedObjectContext) -> RepoManaged? {
        guard let objectId = getManagedObjectId(in: context),
              let object = try? context.notDeletedObject(for: objectId) else {
            return nil
        }
        return try? object.asRepoManaged()
    }
}
