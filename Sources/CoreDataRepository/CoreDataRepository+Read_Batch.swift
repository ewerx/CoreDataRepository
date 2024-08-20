// CoreDataRepository+Read_Batch.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2024 Andrew Roan

import CoreData

extension CoreDataRepository {
    /// Read a batch of unmanaged models.
    ///
    /// This operation is non-atomic. Each instance may succeed or fail individually.
    @inlinable
    public func read<Model: IdentifiedUnmanagedModel>(
        _ ids: some Sequence<Model.UnmanagedId>,
        as _: Model.Type
    ) async -> (success: [Model], failed: [CoreDataBatchError<Model.UnmanagedId>]) {
        var successes = [Model]()
        var failures = [CoreDataBatchError<Model.UnmanagedId>]()
        for id in ids {
            switch await read(id, of: Model.self) {
            case let .success(success):
                successes.append(success)
            case let .failure(error):
                failures.append(.init(item: id, error: error))
            }
        }
        return (success: successes, failed: failures)
    }

    /// Read a batch of unmanaged models.
    ///
    /// This operation is non-atomic. Each instance may succeed or fail individually.
    @inlinable
    public func read<Model>(
        _ items: some Sequence<Model>
    ) async -> (success: [Model], failed: [CoreDataBatchError<Model>]) where Model: ReadableUnmanagedModel {
        var successes = [Model]()
        var failures = [CoreDataBatchError<Model>]()
        for item in items {
            switch await read(item) {
            case let .success(success):
                successes.append(success)
            case let .failure(error):
                failures.append(.init(item: item, error: error))
            }
        }
        return (success: successes, failed: failures)
    }

    /// Read a batch of unmanaged models.
    ///
    /// This operation is non-atomic. Each instance may succeed or fail individually.
    @inlinable
    public func read<Model: FetchableUnmanagedModel>(
        _ managedIds: some Sequence<NSManagedObjectID>,
        as _: Model.Type
    ) async -> (success: [Model], failed: [CoreDataBatchError<NSManagedObjectID>]) {
        var successes = [Model]()
        var failures = [CoreDataBatchError<NSManagedObjectID>]()
        for managedId in managedIds {
            switch await read(managedId, of: Model.self) {
            case let .success(success):
                successes.append(success)
            case let .failure(error):
                failures.append(.init(item: managedId, error: error))
            }
        }
        return (success: successes, failed: failures)
    }

    /// Read a batch of unmanaged models.
    ///
    /// This operation is non-atomic. Each instance may succeed or fail individually.
    @inlinable
    public func read<Model: FetchableUnmanagedModel>(
        _ managedIdUrls: some Sequence<URL>,
        as _: Model.Type
    ) async -> (success: [Model], failed: [CoreDataBatchError<URL>]) {
        var successes = [Model]()
        var failures = [CoreDataBatchError<URL>]()
        for managedIdUrl in managedIdUrls {
            switch await read(managedIdUrl, of: Model.self) {
            case let .success(success):
                successes.append(success)
            case let .failure(error):
                failures.append(.init(item: managedIdUrl, error: error))
            }
        }
        return (success: successes, failed: failures)
    }

    /// Read a batch of unmanaged models.
    ///
    /// This operation is non-atomic. Each instance may succeed or fail individually.
    @inlinable
    public func readAtomically<Model: IdentifiedUnmanagedModel>(
        _ ids: some Sequence<Model.UnmanagedId>,
        as _: Model.Type
    ) async -> Result<[Model], CoreDataError> {
        await context.performInChild(schedule: .enqueued) { readContext in
            try ids.map { id in
                let managed = try Model.readManaged(id: id, from: readContext)
                guard !managed.isDeleted else {
                    throw CoreDataError.fetchedObjectIsFlaggedAsDeleted
                }
                return try Model(managed: managed)
            }
        }
    }

    /// Read a batch of unmanaged models.
    ///
    /// This operation is non-atomic. Each instance may succeed or fail individually.
    @inlinable
    public func readAtomically<Model: ReadableUnmanagedModel>(
        _ items: some Sequence<Model>
    ) async -> Result<[Model], CoreDataError> {
        await context.performInChild(schedule: .enqueued) { readContext in
            try items.map { item in
                let managed = try item.readManaged(from: readContext)
                guard !managed.isDeleted else {
                    throw CoreDataError.fetchedObjectIsFlaggedAsDeleted
                }
                return try Model(managed: managed)
            }
        }
    }

    /// Read a batch of unmanaged models.
    ///
    /// This operation is non-atomic. Each instance may succeed or fail individually.
    @inlinable
    public func readAtomically<Model: FetchableUnmanagedModel>(
        _ managedIds: some Sequence<NSManagedObjectID>,
        as _: Model.Type
    ) async -> Result<[Model], CoreDataError> {
        await context.performInChild(schedule: .enqueued) { readContext in
            try managedIds.map { managedId in
                let _managed = try readContext.notDeletedObject(for: managedId)
                guard let managed = _managed as? Model.ManagedModel else {
                    throw CoreDataError.fetchedObjectFailedToCastToExpectedType
                }
                return try Model(managed: managed)
            }
        }
    }

    /// Read a batch of unmanaged models.
    ///
    /// This operation is non-atomic. Each instance may succeed or fail individually.
    @inlinable
    public func readAtomically<Model: FetchableUnmanagedModel>(
        _ managedIdUrls: some Sequence<URL>,
        as _: Model.Type
    ) async -> Result<[Model], CoreDataError> {
        await context.performInChild(schedule: .enqueued) { readContext in
            try managedIdUrls.map { managedIdUrl in
                let managedId = try readContext.objectId(from: managedIdUrl).get()
                let _managed = try readContext.notDeletedObject(for: managedId)
                guard let managed = _managed as? Model.ManagedModel else {
                    throw CoreDataError.fetchedObjectFailedToCastToExpectedType
                }
                return try Model(managed: managed)
            }
        }
    }
}
