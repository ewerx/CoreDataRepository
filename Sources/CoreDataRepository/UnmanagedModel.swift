// UnmanagedModel.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2022 Andrew Roan

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
  
  /// Fetch the repo managed object from its url
  func getRepoManaged(in context: NSManagedObjectContext) async -> Result<RepoManaged, CoreDataRepositoryError> {
    guard let url = managedRepoUrl else { return .failure(.fetchedObjectFailedToCastToExpectedType) } //TODO: error type
    do {
      let id = try context.tryObjectId(from: url)
      let object = try context.notDeletedObject(for: id)
      let repoManaged: RepoManaged = try object.asRepoManaged()
      return .success(repoManaged)
    } catch let error as CoreDataRepositoryError {
      return .failure(error)
    } catch let error as NSError {
      return .failure(CoreDataRepositoryError.coreData(error))
    }
  }
}
