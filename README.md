<div align="center">

![SwiftNBT Banner](https://placehold.co/800x200/F06292/FFFFFF?text=SwiftNBT&font=montserrat)

![Swift](https://img.shields.io/badge/Swift-6.2+-orange?logo=swift&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-iOS%20|%20macOS%20|%20Linux-lightgrey)
![License](https://img.shields.io/badge/License-MIT-yellow?logo=opensourceinitiative)

</div>

> ⚠️ **Compression & Linkage Notice**
>
> SwiftNBT utilizes the system native **zlib** library for maximum performance when handling GZip/Zlib compressed data (standard for Minecraft).
>
> **For Linux/Server-Side Swift:** Ensure `zlib1g-dev` is installed on your machine.
> **For iOS/macOS:** It works out of the box using the system SDKs.

**SwiftNBT** is a lightweight, zero-dependency (other than system zlib) parser for the **Named Binary Tag (NBT)** format used by Minecraft. It is designed to be robust, type-safe, and incredibly easy to use with modern Swift syntax.

---

## How to Use: Installation

### Swift Package Manager (SPM)

You can add SwiftNBT to your project via Xcode or your `Package.swift` file.

**In `Package.swift`:**

```swift
dependencies: [
    .package(url: "https://github.com/arnaudrmt/SwiftNBT.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["SwiftNBT"]
    )
]
```

**In Xcode:**
1. Go to **File > Add Package Dependencies...**
2. Paste the repository URL.
3. Select the version and add it to your target.

---

## API Usage Examples

### 1. Parsing Raw Data (Base64 or Bytes)

The most common use case is decoding a Base64 string that contains GZipped NBT data.

```swift
import SwiftNBT

let base64String = "H4sIAAAAAAAA/..." // Your data
guard let data = Data(base64Encoded: base64String) else { return }

do {
    // The parser automatically handles GZip decompression
    let rootTag = try NBTParser.parse(data)
    
    print("Parsing successful!")
    rootTag.printTree() // Debug helper to see the structure
} catch {
    print("Error: \(error)")
}
```

### 2. Accessing Data (The Easy Way)

Forget large `switch` statements. Use the built-in optional helpers and subscripts to navigate the NBT tree effortlessly.

```swift
// Accessing a nested path: root -> tag -> display -> Name
if let itemName = rootTag["tag"]?["display"]?["Name"]?.string {
    print("Item Name: \(itemName)")
}

// Accessing lists and arrays
if let inventoryList = rootTag["i"]?.array {
    for (index, item) in inventoryList.enumerated() {
        let count = item["Count"]?.byte ?? 0
        let id = item["id"]?.short ?? 0
        
        print("Slot \(index): ID \(id) x\(count)")
    }
}
```

### 3. Extracting Values

SwiftNBT provides computed properties to safely cast values.

```swift
let tag: NBTTag = ...

// Safe casting (returns nil if type mismatches)
let myInt = tag.int       // Works for Byte, Short, and Int types
let myDouble = tag.double // Works for Float and Double types
let myString = tag.string
```

---

## Features

*   **Auto-Decompression:** Automatically detects and handles GZip and ZLib headers using the native system `zlib`, ensuring 100% compatibility with Minecraft data (RFC 1952).
*   **Type Safety:** Built on a comprehensive `NBTTag` enum that strictly represents every Minecraft data type (Byte, Short, Int, Long, Float, Double, Arrays, Lists, Compounds).
*   **Syntactic Sugar:** Navigate complex NBT trees effortlessly using dictionary-like subscripts (e.g., `tag["display"]["Name"]`) and safe optional casting.
*   **Debug Tools:** Includes a handy `.printTree()` method to visualize the NBT structure hierarchy in the console.
*   **Lightweight:** Zero external dependencies (other than system libraries), keeping your build times fast and binary size small.

---

## Contributing & Maintenance

This library was built to provide a stable, long-term solution for the Swift Minecraft community. **It is here to stay and will be actively maintained.**

We welcome contributions!
*   **Found a bug?** Please open an [Issue](https://github.com/arnaudrmt/SwiftNBT/issues).
*   **Have an improvement?** Feel free to fork the repo and submit a Pull Request.

You don't have to worry about this library becoming deprecated or deleted; we depend on it for our own production apps.
