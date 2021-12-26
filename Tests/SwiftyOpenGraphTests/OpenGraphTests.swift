// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.
//
// In jurisdictions that recognize copyright laws, the author or authors
// of this software dedicate any and all copyright interest in the
// software to the public domain. We make this dedication for the benefit
// of the public at large and to the detriment of our heirs and
// successors. We intend this dedication to be an overt act of
// relinquishment in perpetuity of all present and future rights to this
// software under copyright law.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
// OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// For more information, please refer to <https://unlicense.org>

import XCTest
import SchafKit
@testable import SwiftyOpenGraph

final class OpenGraphTests: XCTestCase {
    
    func getHtml(for url: String) async -> String {
        let result = try! await SKNetworking.request(url: url)
        
        return .init(data: result.data, encoding: .utf8)!
    }
    
    func testMusicAlbum() async throws {
        let url = "https://music.apple.com/us/album/fallen-embers-deluxe-version/1591091543"
        let html = await getHtml(for: url)
        
        guard let graph = OpenGraph(html: html) else {
            XCTFail("No graph object found.")
            return
        }
        
        XCTAssertEqual(graph.title, "Fallen Embers (Deluxe Version) by ILLENIUM")
        XCTAssertEqual(graph.url, url)
        
        XCTAssertEqual(graph.image.url, "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/22/fd/04/22fd0452-fb15-dffb-ea15-15e83a525fdf/093624874690.jpg/1200x1200bf-60.jpg")
        XCTAssertEqual(graph.image.secureUrl, "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/22/fd/04/22fd0452-fb15-dffb-ea15-15e83a525fdf/093624874690.jpg/1200x1200bf-60.jpg")
        XCTAssertEqual(graph.image.alt, "Fallen Embers (Deluxe Version) by ILLENIUM")
        XCTAssertEqual(graph.image.width, 1200)
        XCTAssertEqual(graph.image.height, 1200)
        XCTAssertEqual(graph.image.mimeType, "image/png")
        
        switch graph.type {
        case .album(let album):
            XCTAssertEqual(album.songs.count, 19)
            XCTAssertEqual(album.songs[0].url, "https://music.apple.com/us/album/wouldnt-change-a-thing/1591091543?i=1591091768")
            XCTAssertEqual(album.songs[0].disc, 1)
            XCTAssertEqual(album.songs[0].track, 1)
            XCTAssertEqual(album.songs[0].duration, 187)
            
            XCTAssertEqual(album.musician, "https://music.apple.com/us/artist/illenium/645420096")
            XCTAssertEqual(album.releaseDate, "2021-10-22T00:00:00.000Z")
        
        default:
            XCTFail("Graph type was not album.")
            return
        }
    }
}
