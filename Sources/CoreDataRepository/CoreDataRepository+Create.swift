// CoreDataRepository+Create.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2024 Andrew Roan

import CoreData

extension CoreDataRepository {
    /// Create an instance in the store.
    @inlinable
    public func create<Model>(
        _ item: Model,
        transactionAuthor: String? = nil
    ) async -> Result<Model, CoreDataError> where Model: WritableUnmanagedModel, Model: FetchableUnmanagedModel {
        await context.performInScratchPad(schedule: .enqueued) { [context] scratchPad in
            scratchPad.transactionAuthor = transactionAuthor
            let object = try item.asManagedModel(in: scratchPad)
            let tempObjectId = object.objectID
            try item.updating(managed: object)
            try scratchPad.save()
            try context.performAndWait {
                context.transactionAuthor = transactionAuthor
                do {
                    try context.save()
                } catch {
                    let parentContextObject = context.object(with: tempObjectId)
                    context.delete(parentContextObject)
                    throw error
                }
                context.transactionAuthor = nil
            }
            try scratchPad.obtainPermanentIDs(for: [object])
            return try Model(managed: object)
        }
    }
}
