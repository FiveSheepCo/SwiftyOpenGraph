import Foundation

extension OpenGraphType.VideoAttributes {
    
    public enum SubKind: String, CaseIterable {
        case movie = "video.movie"
        case episode = "video.episode"
        case tvShow = "video.tv_show"
        case other = "video.other"
    }
}
