import XCTest
import SchafKit
@testable import SwiftyOpenGraph

final class OpenGraphTests: XCTestCase {
    
    func getHtml(for url: String) async -> String {
        let result = try! await SKNetworking.request(url: url)
        
        return .init(data: result.data, encoding: .utf8)!
    }
    
    func test(date: Date?, shortUSString: String) {
        XCTAssertNotNil(date)
        
        let formatter = DateFormatter(dateStyle: .short)
        formatter.locale = .init(identifier: "en_US")
        XCTAssertEqual(formatter.string(from: date!), shortUSString)
    }
    
    func getGraph(filename: String) -> OpenGraph? {
        do {
            let thisSourceFile = URL(fileURLWithPath: #file)
            let thisDirectory = thisSourceFile.deletingLastPathComponent().absoluteString
            let html = try String(contentsOf: URL(string: "\(thisDirectory)Examples/\(filename).html")!)
            
            return OpenGraph(html: html)
        }
        catch let err {
            XCTFail("File retrieval failed with error: \(err)")
        }
        return nil
    }
    
    func testRequired() {
        guard let graph = getGraph(filename: "required") else {
            XCTFail("No graph object found.")
            return
        }
        
        XCTAssertEqual(graph.title, "Minimum required properties")
        XCTAssertEqual(graph.url, "http://examples.opengraphprotocol.us/required.html")
        XCTAssertEqual(graph.image.url, "http://examples.opengraphprotocol.us/media/images/50.png")
        XCTAssertNil(graph.image.mimeType)
        XCTAssertEqual(graph.determiner, .blank)
        
        XCTAssertTrue(graph.additionalImages.isEmpty)
    }
    
    func testOptional() {
        guard let graph = getGraph(filename: "optional") else {
            XCTFail("No graph object found.")
            return
        }
        
        XCTAssertEqual(graph.title, "Open Graph protocol examples")
        XCTAssertEqual(graph.url, "http://examples.opengraphprotocol.us/")
        XCTAssertEqual(graph.determiner, .the)
        XCTAssertEqual(graph.locale, "de_DE")
        XCTAssertEqual(graph.alternateLocales, ["en_US", "fr_FR"])
        XCTAssertEqual(graph.image.url, "http://examples.opengraphprotocol.us/media/images/logo.png")
        XCTAssertEqual(graph.image.width, 300)
        XCTAssertEqual(graph.image.height, 300)
        XCTAssertEqual(graph.image.mimeType, "image/png")
        
        XCTAssertTrue(graph.additionalImages.isEmpty)
    }
    
    func testImageArray() {
        guard let graph = getGraph(filename: "image-array") else {
            XCTFail("No graph object found.")
            return
        }
        
        XCTAssertEqual(graph.title, "Two structured image properties")
        XCTAssertEqual(graph.siteName, "Open Graph protocol examples")
        XCTAssertEqual(graph.url, "http://examples.opengraphprotocol.us/image-array.html")
        
        XCTAssertEqual(graph.image.url, "http://examples.opengraphprotocol.us/media/images/75.png")
        XCTAssertEqual(graph.image.secureUrl, "https://d72cgtgi6hvvl.cloudfront.net/media/images/75.png")
        XCTAssertEqual(graph.image.width, 75)
        XCTAssertEqual(graph.image.height, 75)
        XCTAssertEqual(graph.image.mimeType, "image/png")
        XCTAssertEqual(graph.image.alt, "The first image, at 75x75px.")
        
        XCTAssertEqual(graph.additionalImages.count, 1)
        
        XCTAssertEqual(graph.additionalImages[0].url, "http://examples.opengraphprotocol.us/media/images/50.png")
        XCTAssertEqual(graph.additionalImages[0].secureUrl, "https://d72cgtgi6hvvl.cloudfront.net/media/images/50.png")
        XCTAssertEqual(graph.additionalImages[0].width, 50)
        XCTAssertEqual(graph.additionalImages[0].height, 50)
        XCTAssertEqual(graph.additionalImages[0].mimeType, "image/png")
        XCTAssertNil(graph.additionalImages[0].alt)
        
        switch graph.type {
        case .website:
            break
        default:
            XCTFail("Graph type was not album.")
            return
        }
    }
    
    func testImageURL() {
        guard let graph = getGraph(filename: "image-url") else {
            XCTFail("No graph object found.")
            return
        }
        
        XCTAssertEqual(graph.title, "Full structured image property")
        XCTAssertEqual(graph.siteName, "Open Graph protocol examples")
        XCTAssertEqual(graph.url, "http://examples.opengraphprotocol.us/image-url.html")
        
        XCTAssertEqual(graph.image.url, "http://examples.opengraphprotocol.us/media/images/50.png")
        XCTAssertEqual(graph.image.secureUrl, "https://d72cgtgi6hvvl.cloudfront.net/media/images/50.png")
        XCTAssertEqual(graph.image.width, 50)
        XCTAssertEqual(graph.image.height, 50)
        XCTAssertEqual(graph.image.mimeType, "image/png")
        
        XCTAssertTrue(graph.additionalImages.isEmpty)
        
        switch graph.type {
        case .website:
            break
        default:
            XCTFail("Graph type was not album.")
            return
        }
    }
    
    func testAudioArray() {
        guard let graph = getGraph(filename: "audio-array") else {
            XCTFail("No graph object found.")
            return
        }
        
        XCTAssertEqual(graph.title, "Two structured audio properties")
        XCTAssertEqual(graph.siteName, "Open Graph protocol examples")
        XCTAssertEqual(graph.url, "http://examples.opengraphprotocol.us/audio-array.html")
        
        XCTAssertEqual(graph.image.url, "http://examples.opengraphprotocol.us/media/images/50.png")
        XCTAssertEqual(graph.image.secureUrl, "https://d72cgtgi6hvvl.cloudfront.net/media/images/50.png")
        XCTAssertEqual(graph.image.width, 50)
        XCTAssertEqual(graph.image.height, 50)
        XCTAssertEqual(graph.image.mimeType, "image/png")
        
        XCTAssertEqual(graph.audios.count, 2)
        
        XCTAssertEqual(graph.audios[0].url, "http://examples.opengraphprotocol.us/media/audio/1khz.mp3")
        XCTAssertEqual(graph.audios[0].secureUrl, "https://d72cgtgi6hvvl.cloudfront.net/media/audio/1khz.mp3")
        XCTAssertEqual(graph.audios[0].mimeType, "audio/mpeg")
        XCTAssertNil(graph.audios[0].alt)
        
        XCTAssertEqual(graph.audios[1].url, "http://examples.opengraphprotocol.us/media/audio/250hz.mp3")
        XCTAssertEqual(graph.audios[1].secureUrl, "https://d72cgtgi6hvvl.cloudfront.net/media/audio/250hz.mp3")
        XCTAssertEqual(graph.audios[1].mimeType, "audio/mpeg")
        XCTAssertEqual(graph.audios[1].alt, "The second audio, at 250hz.")
        
        switch graph.type {
        case .website:
            break
        default:
            XCTFail("Graph type was not album.")
            return
        }
    }
    
    func testAudioURL() {
        guard let graph = getGraph(filename: "audio-url") else {
            XCTFail("No graph object found.")
            return
        }
        
        XCTAssertEqual(graph.title, "Structured audio property")
        XCTAssertEqual(graph.siteName, "Open Graph protocol examples")
        XCTAssertEqual(graph.url, "http://examples.opengraphprotocol.us/audio-url.html")
        
        XCTAssertEqual(graph.image.url, "http://examples.opengraphprotocol.us/media/images/50.png")
        XCTAssertEqual(graph.image.secureUrl, "https://d72cgtgi6hvvl.cloudfront.net/media/images/50.png")
        XCTAssertEqual(graph.image.width, 50)
        XCTAssertEqual(graph.image.height, 50)
        XCTAssertEqual(graph.image.mimeType, "image/png")
        
        XCTAssertEqual(graph.audios.count, 1)
        
        XCTAssertEqual(graph.audios[0].url, "http://examples.opengraphprotocol.us/media/audio/250hz.mp3")
        XCTAssertEqual(graph.audios[0].secureUrl, "https://d72cgtgi6hvvl.cloudfront.net/media/audio/250hz.mp3")
        XCTAssertEqual(graph.audios[0].mimeType, "audio/mpeg")
        XCTAssertNil(graph.audios[0].alt)
        
        switch graph.type {
        case .website:
            break
        default:
            XCTFail("Graph type was not album.")
            return
        }
    }
    
    func testVideoMovie() {
        guard let graph = getGraph(filename: "video-movie") else {
            XCTFail("No graph object found.")
            return
        }
        
        XCTAssertEqual(graph.title, "Arrival of a Train at La Ciotat")
        XCTAssertEqual(graph.description, "L'arrivée d'un train en gare de La Ciotat is an 1895 French short black-and-white silent documentary film directed and produced by Auguste and Louis Lumière. Its first public showing took place in January 1896.")
        XCTAssertEqual(graph.locale, "en_US")
        XCTAssertEqual(graph.url, "http://examples.opengraphprotocol.us/video-movie.html")
        
        XCTAssertEqual(graph.image.url, "http://examples.opengraphprotocol.us/media/images/train.jpg")
        XCTAssertEqual(graph.image.secureUrl, "https://d72cgtgi6hvvl.cloudfront.net/media/images/train.jpg")
        XCTAssertEqual(graph.image.width, 500)
        XCTAssertEqual(graph.image.height, 328)
        XCTAssertEqual(graph.image.mimeType, "image/jpeg")
        
        XCTAssertTrue(graph.audios.isEmpty)
        
        XCTAssertEqual(graph.videos.count, 3)
        
        XCTAssertEqual(graph.videos[0].url, "http://fpdownload.adobe.com/strobe/FlashMediaPlayback.swf?src=http%3A%2F%2Fexamples.opengraphprotocol.us%2Fmedia%2Fvideo%2Ftrain.mp4")
        XCTAssertEqual(graph.videos[0].secureUrl, "https://fpdownload.adobe.com/strobe/FlashMediaPlayback.swf?src=https%3A%2F%2Fd72cgtgi6hvvl.cloudfront.net%2Fmedia%2Fvideo%2Ftrain.mp4")
        XCTAssertEqual(graph.videos[0].mimeType, "application/x-shockwave-flash")
        XCTAssertEqual(graph.videos[0].width, 472)
        XCTAssertEqual(graph.videos[0].height, 296)
        XCTAssertNil(graph.videos[0].alt)
        
        XCTAssertEqual(graph.videos[1].mimeType, "video/mp4")
        XCTAssertEqual(graph.videos[1].width, 472)
        XCTAssertEqual(graph.videos[1].height, 296)
        XCTAssertNil(graph.videos[1].alt)
        
        XCTAssertEqual(graph.videos[2].mimeType, "video/webm")
        XCTAssertEqual(graph.videos[2].width, 480)
        XCTAssertEqual(graph.videos[2].height, 320)
        XCTAssertNil(graph.videos[2].alt)
        
        switch graph.type {
        case .video(let attributes):
            XCTAssertEqual(attributes.kind, .movie)
            let formatter = DateFormatter(dateStyle: .short)
            formatter.locale = .init(identifier: "en_US")
            XCTAssertEqual(formatter.string(from: attributes.releaseDate!), "12/28/95")
            XCTAssertEqual(attributes.directors, ["http://examples.opengraphprotocol.us/profile.html"])
            XCTAssertEqual(attributes.duration, 50)
            XCTAssertEqual(attributes.tags, ["La Ciotat", "train"])
            break
        default:
            XCTFail("Graph type was not album.")
            return
        }
    }
    
    func testMin() {
        XCTAssertNil(getGraph(filename: "min"))
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
            test(date: album.releaseDate, shortUSString: "10/22/21")
        
        default:
            XCTFail("Graph type was not album.")
            return
        }
    }
}
