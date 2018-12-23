import Foundation

public enum Result<Value> {
    case success(Value)
    case error(Error)

    public init(success value: Value) {
        self = .success(value)
    }

    public init(error: Error) {
        self = .error(error)
    }

    public func map<NewValue>(_ transform: (Value) -> NewValue) -> Result<NewValue> {
        switch self {
        case let .success(success):
            return .success(transform(success))
        case let .error(error):
            return .error(error)
        }
    }
}
