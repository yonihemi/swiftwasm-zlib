import XCTest
@testable import SwiftWasmZlib

final class SwiftWasmZlibTests: XCTestCase {
    func testVersion() {
        XCTAssertEqual(ZLIB_VERSION, "1.2.8.f-swiftwasm")
    }

    func testDeflate() {
        let outputBufferSize = 1024
        var compressedBytes: [UInt8] = [
            0x1f, 0x8b, 0x08, 0x00, 0x2e, 0x15, 0xcf, 0x4e, 0x00, 0x03, 0xcb, 0x48,
            0xcd, 0xc9, 0xc9, 0xd7, 0x51, 0xc8, 0xce, 0x2c, 0x29, 0xc9, 0x4c, 0x2d,
            0xe6, 0x02, 0x00, 0x82, 0xe4, 0x0c, 0x1c, 0x0f, 0x00, 0x00, 0x00]
        let inputSize = compressedBytes.count
        var outputBuffer = [UInt8](repeating: 0, count: outputBufferSize)
        
        compressedBytes.withUnsafeMutableBytes { input in
            outputBuffer.withUnsafeMutableBytes { output in
                var stream = z_stream()
                stream.avail_in = UInt32(inputSize)
                stream.next_in = input.bindMemory(to: UInt8.self).baseAddress
                
                var retValue = inflateInit2_(&stream, 15 + 32, ZLIB_VERSION, Int32(MemoryLayout<z_stream>.size))
                XCTAssertEqual(retValue, Z_OK)
            
                stream.avail_out = UInt32(outputBufferSize)
                stream.next_out = output.bindMemory(to: UInt8.self).baseAddress
                retValue = inflate(&stream, Z_NO_FLUSH)
                XCTAssertEqual(retValue, Z_STREAM_END)
                
                inflateEnd(&stream)
                
                let outputString = String(cString: output.bindMemory(to: UInt8.self).baseAddress!)
                print(outputString)
                XCTAssertEqual(outputString, "hello, kitties\n")
            }
        }
    }

    static var allTests = [
        ("testVersion", testVersion),
        ("testDeflate", testDeflate),
    ]
}
