//
//  File.swift
//  SwiftNBT
//
//  Created by Arnaud on 28/11/2025.
//

import Foundation

/// Internal utility class to read binary data sequentially (Big Endian).
internal class NBTStream {
    private let data: Data
    private var offset: Int = 0
    
    init(data: Data) {
        self.data = data
    }
    
    // MARK: - Core Reading
    
    func readByte() throws -> UInt8 {
        guard offset < data.count else { throw NBTError.endOfStream }
        let b = data[offset]
        offset += 1
        return b
    }
    
    func readBytes(_ count: Int) throws -> Data {
        guard offset + count <= data.count else { throw NBTError.endOfStream }
        let sub = data.subdata(in: offset..<(offset + count))
        offset += count
        return sub
    }
    
    // MARK: - Primitives (Big Endian)
    
    func readInt8() throws -> Int8 {
        return Int8(bitPattern: try readByte())
    }
    
    func readInt16() throws -> Int16 {
        let data = try readBytes(2)
        return Int16(bigEndian: data.withUnsafeBytes { $0.load(as: Int16.self) })
    }
    
    func readInt32() throws -> Int32 {
        let data = try readBytes(4)
        return Int32(bigEndian: data.withUnsafeBytes { $0.load(as: Int32.self) })
    }
    
    func readInt64() throws -> Int64 {
        let data = try readBytes(8)
        return Int64(bigEndian: data.withUnsafeBytes { $0.load(as: Int64.self) })
    }
    
    func readFloat() throws -> Float {
        let bits = try readInt32()
        return Float(bitPattern: UInt32(bitPattern: bits))
    }
    
    func readDouble() throws -> Double {
        let bits = try readInt64()
        return Double(bitPattern: UInt64(bitPattern: bits))
    }
    
    func readString() throws -> String {
        let length = try readInt16()
        let data = try readBytes(Int(length))
        guard let str = String(data: data, encoding: .utf8) else {
            throw NBTError.invalidString
        }
        return str
    }
}
