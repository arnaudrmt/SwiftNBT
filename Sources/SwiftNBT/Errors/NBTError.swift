//
//  File.swift
//  SwiftNBT
//
//  Created by Arnaud on 28/11/2025.
//

import Foundation

/// Represents errors that can occur during NBT parsing or GZip decompression.
public enum NBTError: Error {
    /// The end of the data stream was reached unexpectedly.
    case endOfStream
    /// The string format within the NBT data is invalid (not UTF-8).
    case invalidString
    /// The NBT tag ID is unknown or unsupported.
    case unknownTagId(UInt8)
    /// The file format does not match standard NBT (e.g., missing root compound).
    case invalidFormat
    /// Failed to initialize the zlib stream for decompression.
    case streamInitializationFailed
    /// Failed to decompress the GZip data.
    case decompressionFailed
}
