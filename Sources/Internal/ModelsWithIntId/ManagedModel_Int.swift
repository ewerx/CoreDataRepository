// ManagedModel_Int.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2024 Andrew Roan

import CoreData
import Foundation

@objc(ManagedModel_IntId)
package final class ManagedModel_IntId: BaseManagedModel {
    @NSManaged package var id: Int
}

extension ManagedModel_IntId {
    override package class func entity() -> NSEntityDescription {
        entityDescription
    }

    package static let entityDescription: NSEntityDescription = {
        let desc = NSEntityDescription()
        desc.name = "ManagedModel_IntId"
        desc.managedObjectClassName = NSStringFromClass(ManagedModel_IntId.self)
        desc.properties = attributeDescriptions(appending: [idDescription])
        desc.uniquenessConstraints = [[idDescription]]
        desc.indexes = [NSFetchIndexDescription(
            name: "id",
            elements: [NSFetchIndexElementDescription(
                property: ManagedModel_IntId.idDescription,
                collationType: .binary
            )]
        )]
        return desc
    }()

    package static var idDescription: NSAttributeDescription {
        let desc = NSAttributeDescription()
        desc.name = "id"
        desc.attributeType = .integer64AttributeType
        return desc
    }
}
