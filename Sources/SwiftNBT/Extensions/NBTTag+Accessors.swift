//
//  File.swift
//  SwiftNBT
//
//  Created by Arnaud on 28/11/2025.
//

import Foundation

// MARK: - Convenience Accessors
public extension NBTTag {
    
    /// Returns the String value if the tag is a String tag.
    var string: String? {
        if case .string(let s) = self { return s }
        return nil
    }
    
    /// Returns the value as Int (supports Byte, Short, Int).
    var int: Int? {
        if case .int(let i) = self { return Int(i) }
        if case .byte(let b) = self { return Int(b) }
        if case .short(let s) = self { return Int(s) }
        return nil
    }
    
    /// Returns the value as Double (supports Float, Double).
    var double: Double? {
        if case .double(let d) = self { return d }
        if case .float(let f) = self { return Double(f) }
        return nil
    }
    
    /// Returns the specific Short value cast to Int.
    var short: Int? {
        if case .short(let s) = self { return Int(s) }
        return nil
    }

    /// Returns the specific Byte value cast to Int.
    var byte: Int? {
        if case .byte(let b) = self { return Int(b) }
        return nil
    }
    
    /// Returns the array of tags if this is a List tag.
    var array: [NBTTag]? {
        if case .list(let list) = self { return list }
        return nil
    }
    
    // MARK: - Subscripts
    
    /// Accesses a value in a Compound tag by key.
    subscript(key: String) -> NBTTag? {
        if case .compound(let dict) = self {
            return dict[key]
        }
        return nil
    }
    
    /// Accesses a value in a List, ByteArray or IntArray by index.
    subscript(index: Int) -> NBTTag? {
        switch self {
        case .list(let list):
            return list.indices.contains(index) ? list[index] : nil
        case .byteArray(let bytes):
            return bytes.indices.contains(index) ? .byte(bytes[index]) : nil
        case .intArray(let ints):
            return ints.indices.contains(index) ? .int(ints[index]) : nil
        default:
            return nil
        }
    }
}

// MARK: - Debugging
public extension NBTTag {
    /// Prints a tree representation of the NBT structure for debugging.
    func printTree() {
        print(self.debugDescription(indent: 0))
    }
    
    private func debugDescription(indent: Int) -> String {
        let spaces = String(repeating: "  ", count: indent)
        switch self {
        case .compound(let dict):
            var s = "{\n"
            let sortedKeys = dict.keys.sorted()
            for k in sortedKeys {
                if let v = dict[k] {
                    s += "\(spaces)  \(k): \(v.debugDescription(indent: indent + 1))\n"
                }
            }
            s += "\(spaces)}"
            return s
        case .list(let list):
            return "[\(list.count) items] " + (list.isEmpty ? "" : "...")
        case .string(let s): return "\"\(s)\""
        case .int(let i): return "\(i)"
        case .byte(let b): return "\(b)b"
        case .short(let s): return "\(s)s"
        default: return "\(self)"
        }
    }
}
