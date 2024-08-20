// ManagedModel_Uuid.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2024 Andrew Roan

import CoreData
import Foundation

@objc(ManagedModel_UuidId)
package final class ManagedModel_UuidId: BaseManagedModel {
    @NSManaged package var id: UUID
}

extension ManagedModel_UuidId {
    override package class func entity() -> NSEntityDescription {
        entityDescription
    }

    package static let entityDescription: NSEntityDescription = {
        let desc = NSEntityDescription()
        desc.name = "ManagedModel_UuidId"
        desc.managedObjectClassName = NSStringFromClass(ManagedModel_UuidId.self)
        desc.properties = attributeDescriptions(appending: [idDescription])
        desc.uniquenessConstraints = [[idDescription]]
        desc.indexes = [NSFetchIndexDescription(
            name: "id",
            elements: [NSFetchIndexElementDescription(
                property: ManagedModel_UuidId.idDescription,
                collationType: .binary
            )]
        )]
        return desc
    }()

    package static var idDescription: NSAttributeDescription {
        let desc = NSAttributeDescription()
        desc.name = "id"
        desc.attributeType = .UUIDAttributeType
        return desc
    }
}
