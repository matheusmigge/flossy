//
//  FlossActivity.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 25/06/26.
//


public enum FlossActivity: String, CaseIterable, Sendable {
    case floss
    case brush
    case mouthwash
    
    init(from detail: FlossRecord.Detail) {
        switch detail {
        case .brush:
            self = .brush
        case .floss:
            self = .floss
        case .mouthwash:
            self = .mouthwash
        }
    }
}
