//
//  File.swift
//  SwiftNBT
//
//  Created by Arnaud on 28/11/2025.
//

/// Represents a Minecraft Named Binary Tag (NBT).
/// Reference: https://wiki.vg/NBT
public enum NBTTag: Equatable {
    case end
    case byte(Int8)
    case short(Int16)
    case int(Int32)
    case long(Int64)
    case float(Float)
    case double(Double)
    case byteArray([Int8])
    case string(String)
    case list([NBTTag])
    case compound([String: NBTTag])
    case intArray([Int32])
    case longArray([Int64])
    
    /// The official numeric ID of the tag used in the binary format.
    internal var id: UInt8 {
        switch self {
        case .end: return 0
        case .byte: return 1
        case .short: return 2
        case .int: return 3
        case .long: return 4
        case .float: return 5
        case .double: return 6
        case .byteArray: return 7
        case .string: return 8
        case .list: return 9
        case .compound: return 10
        case .intArray: return 11
        case .longArray: return 12
        }
    }
}
