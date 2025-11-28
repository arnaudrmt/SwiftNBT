//
//  File.swift
//  SwiftNBT
//
//  Created by Arnaud on 28/11/2025.
//

import Foundation
import zlib

public extension Data {
    
    /// Checks if the data starts with the GZip magic number (0x1f, 0x8b).
    var isGzipped: Bool {
        return self.count >= 2 && self[0] == 0x1f && self[1] == 0x8b
    }
    
    /// Decompresses GZip data using the system `zlib`.
    /// Handles both standard GZip and ZLib headers.
    func gunzipped() throws -> Data {
        guard isGzipped else { return self }
        
        var stream = z_stream()
        var status: Int32
        
        // WindowBits 31 (15 + 16) enables GZip header detection
        status = inflateInit2_(&stream, 15 + 32, ZLIB_VERSION, Int32(MemoryLayout<z_stream>.size))
        
        guard status == Z_OK else {
            throw NBTError.streamInitializationFailed
        }
        
        var decompressed = Data(capacity: self.count * 2)
        let bufferSize = 4096
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer {
            buffer.deallocate()
            inflateEnd(&stream)
        }
        
        return try self.withUnsafeBytes { (byteBuffer: UnsafeRawBufferPointer) in
            guard let baseAddress = byteBuffer.baseAddress else { throw NBTError.decompressionFailed }
            
            stream.next_in = UnsafeMutablePointer<UInt8>(mutating: baseAddress.assumingMemoryBound(to: UInt8.self))
            stream.avail_in = uInt(byteBuffer.count)
            
            while stream.avail_in > 0 {
                stream.next_out = buffer
                stream.avail_out = uInt(bufferSize)
                
                status = inflate(&stream, Z_NO_FLUSH)
                
                if status != Z_OK && status != Z_STREAM_END {
                    throw NBTError.decompressionFailed
                }
                
                let dataProcessed = bufferSize - Int(stream.avail_out)
                if dataProcessed > 0 {
                    decompressed.append(buffer, count: dataProcessed)
                }
                
                if status == Z_STREAM_END {
                    break
                }
            }
            return decompressed
        }
    }
}
