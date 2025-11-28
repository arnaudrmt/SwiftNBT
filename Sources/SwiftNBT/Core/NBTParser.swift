//
//  File.swift
//  SwiftNBT
//
//  Created by Arnaud on 28/11/2025.
//

import Foundation

/// The main entry point for parsing NBT Data.
public class NBTParser {
    
    /// Parses raw NBT data into an `NBTTag` structure.
    /// Automatically handles GZip decompression if needed.
    ///
    /// - Parameter data: The raw data (can be Base64 decoded data, or raw bytes).
    /// - Returns: The root `NBTTag` (usually a Compound).
    /// - Throws: `NBTError` if parsing or decompression fails.
    public static func parse(_ data: Data) throws -> NBTTag {
        // 1. Attempt automatic GZip decompression
        let rawData = try data.gunzipped()
        
        // 2. Start parsing stream
        let stream = NBTStream(data: rawData)
        return try parseRoot(stream: stream)
    }
    
    // MARK: - Internal Parsing Logic
    
    private static func parseRoot(stream: NBTStream) throws -> NBTTag {
        let typeId = try stream.readByte()
        
        if typeId == 0 { return .end } // Empty file
        
        // Root is always a named compound (ID 10)
        if typeId != 10 {
            throw NBTError.invalidFormat
        }
        
        // Root tags have a name (often empty string), we consume it but don't store it here
        _ = try stream.readString()
        
        return try readTagPayload(id: 10, stream: stream)
    }
    
    private static func readTagPayload(id: UInt8, stream: NBTStream) throws -> NBTTag {
        switch id {
        case 1: return .byte(try stream.readInt8())
        case 2: return .short(try stream.readInt16())
        case 3: return .int(try stream.readInt32())
        case 4: return .long(try stream.readInt64())
        case 5: return .float(try stream.readFloat())
        case 6: return .double(try stream.readDouble())
            
        case 7: // Byte Array
            let length = try stream.readInt32()
            var bytes: [Int8] = []
            // Optimization: could read bytes in bulk, but loop is safer for endianness
            for _ in 0..<length { bytes.append(try stream.readInt8()) }
            return .byteArray(bytes)
            
        case 8: return .string(try stream.readString())
            
        case 9: // List
            let elementTypeId = try stream.readByte()
            let length = try stream.readInt32()
            var list: [NBTTag] = []
            for _ in 0..<length {
                list.append(try readTagPayload(id: elementTypeId, stream: stream))
            }
            return .list(list)
            
        case 10: // Compound
            var dict: [String: NBTTag] = [:]
            while true {
                let nextId = try stream.readByte()
                if nextId == 0 { break } // Tag_End
                
                let name = try stream.readString()
                let value = try readTagPayload(id: nextId, stream: stream)
                dict[name] = value
            }
            return .compound(dict)
            
        case 11: // Int Array
            let length = try stream.readInt32()
            var ints: [Int32] = []
            for _ in 0..<length { ints.append(try stream.readInt32()) }
            return .intArray(ints)
            
        case 12: // Long Array
            let length = try stream.readInt32()
            var longs: [Int64] = []
            for _ in 0..<length { longs.append(try stream.readInt64()) }
            return .longArray(longs)
            
        default:
            throw NBTError.unknownTagId(id)
        }
    }
}
