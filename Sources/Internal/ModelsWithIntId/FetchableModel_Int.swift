// FetchableModel_Int.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2024 Andrew Roan

import CoreDataRepository
import Foundation

package struct FetchableModel_IntId: Hashable, Sendable {
    package var bool: Bool
    package var date: Date
    package var decimal: Decimal
    package var double: Double
    package var float: Float
    package var int: Int
    package var string: String
    package var uuid: UUID

    @inlinable
    package init(
        bool: Bool,
        date: Date,
        decimal: Decimal,
        double: Double,
        float: Float,
        int: Int,
        string: String,
        uuid: UUID
    ) {
        self.bool = bool
        self.date = date
        self.decimal = decimal
        self.double = double
        self.float = float
        self.int = int
        self.string = string
        self.uuid = uuid
    }

    @inlinable
    package static func defaulted(
        bool: Bool = true,
        date: Date = Date(),
        decimal: Decimal = 0,
        double: Double = 0,
        float: Float = 0,
        int: Int = 0,
        string: String = "",
        uuid: UUID = UUID()
    ) -> Self {
        Self(
            bool: bool,
            date: date,
            decimal: decimal,
            double: double,
            float: float,
            int: int,
            string: string,
            uuid: uuid
        )
    }

    @inlinable
    package static func seeded(_ seed: Int) -> Self {
        let _uuid = UUID(uniform: seed.description.first!)
        return Self(
            bool: seed.isMultiple(of: 2) ? true : false,
            date: Date(timeIntervalSinceReferenceDate: TimeInterval(seed)),
            decimal: Decimal(seed),
            double: Double(seed),
            float: Float(seed),
            int: seed,
            string: seed.description,
            uuid: _uuid
        )
    }
}

extension FetchableModel_IntId: FetchableUnmanagedModel {
    @inlinable
    package init(managed: ManagedModel_IntId) throws {
        self.init(
            bool: managed.bool,
            date: managed.date,
            decimal: managed.decimal as Decimal,
            double: managed.double,
            float: managed.float,
            int: managed.int,
            string: managed.string,
            uuid: managed.uuid
        )
    }
}

extension FetchableModel_IntId: WritableUnmanagedModel {
    @inlinable
    package func updating(managed: ManagedModel) throws {
        managed.bool = bool
        managed.date = date
        managed.decimal = decimal as NSDecimalNumber
        managed.double = double
        managed.float = float
        managed.id = int
        managed.int = int
        managed.string = string
        managed.uuid = uuid
    }
}

extension FetchableModel_IntId: Comparable {
    package static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.int < rhs.int
    }
}
