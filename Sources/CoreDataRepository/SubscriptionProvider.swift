// SubscriptionProvider.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2022 Andrew Roan

public protocol SubscriptionProvider {
    var id: AnyHashable { get }
    func manualFetch()
    func cancel()
    func start()
}
