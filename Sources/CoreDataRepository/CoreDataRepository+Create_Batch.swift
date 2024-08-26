// CoreDataRepository+Create_Batch.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2024 Andrew Roan

import CoreData

extension CoreDataRepository {
    /// Create a batch of unmanaged models.
    ///
    /// This operation is non-atomic. Each instance may succeed or fail individually.
    @inlinable
    public func create<Model>(
        _ items: [Model],
        transactionAuthor: String? = nil
    ) async -> (success: [Model], failed: [CoreDataBatchError<Model>]) where Model: FetchableUnmanagedModel,
        Model: WritableUnmanagedModel
    {
        var successes = [Model]()
        var failures = [CoreDataBatchError<Model>]()
        for item in items {
            switch await create(item, transactionAuthor: transactionAuthor) {
            case let .success(success):
                successes.append(success)
            case let .failure(error):
                failures.append(.init(item: item, error: error))
            }
        }
        return (success: successes, failed: failures)
    }

    /// Create a batch of unmanaged models.
    @inlinable
    public func createAtomically<Model>(
        _ items: [Model],
        transactionAuthor: String? = nil
    ) async -> Result<[Model], CoreDataError> where Model: FetchableUnmanagedModel, Model: WritableUnmanagedModel {
        await context.performInScratchPad(schedule: .enqueued) { [context] scratchPad in
            scratchPad.transactionAuthor = transactionAuthor
            let objects = try items.map { item in
                let object = try item.asManagedModel(in: scratchPad)
                return object
            }
            try scratchPad.save()
            try context.performAndWait {
                context.transactionAuthor = transactionAuthor
                try context.save()
                context.transactionAuthor = nil
            }
            try scratchPad.obtainPermanentIDs(for: objects)
            return try objects.map(Model.init(managed:))
        }
    }
}
