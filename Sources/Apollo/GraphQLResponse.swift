/// Represents a GraphQL response received from a server.
public final class GraphQLResponse<Data: GraphQLSelectionSet>: Parseable{
  
  public init<T>(from data: Foundation.Data, decoder: T) throws where T : FlexibleDecoder {
    // Giant hack to make all this conform to Parseable.
    throw ParseableError.unsupportedInitializer
  }
  
  public let body: JSONObject

  private var rootKey: String
  private var variables: GraphQLMap?

  public init<Operation: GraphQLOperation>(operation: Operation, body: JSONObject) where Operation.Data == Data {
    self.body = body
    rootKey = rootCacheKey(for: operation)
    variables = operation.variables
  }
  
  func setupOperation<Operation: GraphQLOperation> (_ operation: Operation) {
    self.rootKey = rootCacheKey(for: operation)
    self.variables = operation.variables
  }

  func parseResult(cacheKeyForObject: CacheKeyForObject? = nil) throws -> Promise<(GraphQLResult<Data>, RecordSet?)>  {
    let errors: [GraphQLError]?

    if let errorsEntry = body["errors"] as? [JSONObject] {
      errors = errorsEntry.map(GraphQLError.init)
    } else {
      errors = nil
    }

    if let dataEntry = body["data"] as? JSONObject {
      let executor = GraphQLExecutor { object, info in
        return .result(.success(object[info.responseKeyForField]))
      }

      executor.cacheKeyForObject = cacheKeyForObject

      let mapper = GraphQLSelectionSetMapper<Data>()
      let normalizer = GraphQLResultNormalizer()
      let dependencyTracker = GraphQLDependencyTracker()

      return firstly {
        try executor.execute(selections: Data.selections,
                             on: dataEntry,
                             withKey: rootKey,
                             variables: variables,
                             accumulator: zip(mapper, normalizer, dependencyTracker))
        }.map { (data, records, dependentKeys) in
          (
            GraphQLResult(data: data,
                         errors: errors,
                         source: .server,
                         dependentKeys: dependentKeys),
            records
          )
      }
    } else {
      return Promise(fulfilled: (
        GraphQLResult(data: nil,
                      errors: errors,
                      source: .server,
                      dependentKeys: nil),
        nil
      ))
    }
  }

  func parseErrorsOnlyFast() -> [GraphQLError]? {
    guard let errorsEntry = self.body["errors"] as? [JSONObject] else {
      return nil
    }

    return errorsEntry.map(GraphQLError.init)
  }

  func parseResultFast() throws -> GraphQLResult<Data>  {
    let errors = self.parseErrorsOnlyFast()

    if let dataEntry = body["data"] as? JSONObject {
      let data = try decode(selectionSet: Data.self,
                            from: dataEntry,
                            variables: variables)

      return GraphQLResult(data: data,
                           errors: errors,
                           source: .server,
                           dependentKeys: nil)
    } else {
      return GraphQLResult(data: nil,
                           errors: errors,
                           source: .server,
                           dependentKeys: nil)
    }
  }
}
