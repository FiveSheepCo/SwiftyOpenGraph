# SwiftyOpenGraph

[![GithubCI_Status]][GithubCI_URL] [![LICENSE_BADGE]][LICENSE_URL] ![Platform](https://img.shields.io/badge/platforms-iOS%2013.0%20%7C%20macOS%2010.15%20%7C%20tvOS%2013.0%20%7C%20watchOS%206.0-F28D00.svg)

-  [Usage](#usage)
    - [Initialization](#initialization)
    - [Base Properties](#base-properties)
    - [Types](#types)
-  [Installation](#installation)
-  [License](#license)

# Usage

## Initialization

You use SwiftyOpenGraph by initializing `OpenGraph`, the root object of SwiftyOpenGraph. There are two initializers of `OpenGraph`:

### HTML String
```swift
let graph = OpenGraph(html: htmlString)
```

### URL
```swift
let graph = try await OpenGraph(url: "https://quintschaf.com/#/app/mykeyboard")
```

Both of these initializers are optional, only returning when the html contains at least the required OpenGraph properties.

## Base Properties

Every valid open graph enabled webpage has four properties, which an `OpenGraph` object exposes as non-optional constants: `title`, `type`, `image` and `url`. It can also contain `additionalImages`, `audios`, `videos`, `description`, `determiner`, `locale`, `alternateLocales` and `siteName`. These are either optional constants of an `OpenGraph` object or they contain the default value as defined by the OpenGraph protocol.

Images, Audios, Videos and the Determiner are represented by `OpenGraphImage`, `OpenGraphAudio`, `OpenGraphVideo` and `Determiner`. All of them are structs that may contain additional data, e.g. the width of an image, represented by the `"og:image:width"` meta tag.

Example:
```swift
print(graph.title)  // "MyKeyboard"
print(graph.type)   // OpenGraphType.website
print(graph.image)  // OpenGraphImage(url: "...", width: ...)
print(graph.url)    // "https://quintschaf.com/#/app/mykeyboard"

print(graph.additionalImages)   // []
print(graph.audios)             // []
print(graph.videos)             // []
print(graph.description)        // Optional("The fully customizable Keyboard.")
print(graph.determiner)         // Determiner.blank
print(graph.locale)             // "en_US"
print(graph.alternateLocales)   // []
print(graph.siteName)           // nil
```

## Types

The type (`"og:type"`) is represented by the `OpenGraphType` enum, which has the following cases (as specified by the OpenGraph spec):
- `song(SongAttributes)`
- `album(AlbumAttributes)`
- `playlist(PlaylistAttributes)`
- `radioStation(RadioStationAttributes)`
- `video(VideoAttributes)`
- `article(ArticleAttributes)`
- `book(BookAttributes)`
- `profile(ProfileAttributes)`
- `website`

All of these (with the exception of the default type `website`) have a struct as an associated value. These structs hold the values that are specific to the type. Due to their differences in properties, there are seperate cases for `song`, `album`, `playlist` and `radioStation`. Due to them having almost the same properties, there is only one `video` case for all video types. The `VideoAttributes` therefor contains a `kind` property that is an enumeration containing all the video types.

Example:
```swift
switch graph.type {
case .video(let attributes):
    print(attributes.kind)          // VideoAttributes.SubKind.movie
    print(attributes.actors)        // []
    print(attributes.directors)     // []
    print(attributes.writers)       // []
    print(attributes.duration)      // Optional(200)
    print(attributes.releaseDate)   // Optional(Date(...))
    print(attributes.tags)          // ["some", "words", "as", "tags"]
    print(attributes.series)        // nil
default:
    break
}
```

# Installation

### Swift Package Manager

SwiftyOpenGraph relies on Swift Package Manager and is installed by adding it as a dependency.

# License

We have chosen to use the CC0 1.0 Universal license for SwiftyOpenGraph. The following short explanation has no legal implication whatsoever and does not override the license in any way: CC0 1.0 Universal license gives you the right to use or modify all of SwiftyOpenGraphs code in any (commercial or non-commercial) product without mentioning, licensing or other headaches of any kind.

# Background

When we were trying to find an OpenGraph implementation in Swift there was only one result. That result was using Regular Expressions to parse the meta tags, which we find unacceptable. So we set out to create one that uses `SwiftSoup` to properly parse the html of a webpage. We also wanted to make sure this project is a perfect 1:1 abstraction of the OpenGraph protocol into Swift. If there are any additions or changes made to the protocol, we will adopt them as fast as possible.

<!-- References -->

[GithubCI_Status]: https://github.com/Quintschaf/SwiftyOpenGraph/actions/workflows/swift.yml/badge.svg?branch=main
[GithubCI_URL]: https://github.com/Quintschaf/SwiftyOpenGraph/actions/workflows/swift.yml
[LICENSE_BADGE]: https://badgen.net/github/license/quintschaf/SwiftyOpenGraph
[LICENSE_URL]: https://github.com/Quintschaf/SwiftyOpenGraph/blob/master/LICENSE
