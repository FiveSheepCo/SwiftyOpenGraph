import Foundation

extension OpenGraph {
    
    /// An enum of (`a`, `an`, `the`, "", `auto`). If `auto` is chosen, the consumer of your data should chose between `a` or `an`.
    public enum Determiner: String {
        case a, an, the, blank = "", auto
    }
}
