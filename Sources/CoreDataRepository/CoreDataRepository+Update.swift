// CoreDataRepository+Update.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2024 Andrew Roan

import CoreData
import Foundation

extension CoreDataRepository {
    /// Update the store with an unmanaged model.
    @inlinable
    public func update<Model>(
        with item: Model,
        transactionAuthor: String? = nil
    ) async -> Result<Model, CoreDataError> where Model: ReadableUnmanagedModel, Model: WritableUnmanagedModel {
        await context.performInScratchPad(schedule: .enqueued) { [context] scratchPad in
            scratchPad.transactionAuthor = transactionAuthor
            let managed = try item.readManaged(from: scratchPad)
            try item.updating(managed: managed)
            try scratchPad.save()
            try context.performAndWait {
                context.transactionAuthor = transactionAuthor
                try context.save()
                context.transactionAuthor = nil
            }
            return try Model(managed: managed)
        }
    }

    /// Update the store with an unmanaged model.
    @inlinable
    public func update<Model: UnmanagedModel>(
        _ managedId: NSManagedObjectID,
        with item: Model,
        transactionAuthor: String? = nil
    ) async -> Result<Model, CoreDataError> where Model: FetchableUnmanagedModel, Model: WritableUnmanagedModel {
        await context.performInScratchPad(schedule: .enqueued) { [context] scratchPad in
            scratchPad.transactionAuthor = transactionAuthor
            let object = try scratchPad.notDeletedObject(for: managedId)
            let repoManaged: Model.ManagedModel = try object.asManagedModel()
            try item.updating(managed: repoManaged)
            try scratchPad.save()
            try context.performAndWait {
                context.transactionAuthor = transactionAuthor
                try context.save()
                context.transactionAuthor = nil
            }
            return try Model(managed: repoManaged)
        }
    }

    /// Update the store with an unmanaged model.
    @inlinable
    public func update<Model: UnmanagedModel>(
        _ managedIdUrl: URL,
        with item: Model,
        transactionAuthor: String? = nil
    ) async -> Result<Model, CoreDataError> where Model: FetchableUnmanagedModel, Model: WritableUnmanagedModel {
        await context.performInScratchPad(schedule: .enqueued) { [context] scratchPad in
            scratchPad.transactionAuthor = transactionAuthor
            let id = try scratchPad.objectId(from: managedIdUrl).get()
            let object = try scratchPad.notDeletedObject(for: id)
            let repoManaged: Model.ManagedModel = try object.asManagedModel()
            try item.updating(managed: repoManaged)
            try scratchPad.save()
            try context.performAndWait {
                context.transactionAuthor = transactionAuthor
                try context.save()
                context.transactionAuthor = nil
            }
            return try Model(managed: repoManaged)
        }
    }
}
