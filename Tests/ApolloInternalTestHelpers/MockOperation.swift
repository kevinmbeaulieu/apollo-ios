@testable import ApolloAPI

open class MockOperation<SelectionSet: RootSelectionSet>: GraphQLOperation {
  public typealias Data = SelectionSet

  open class var operationType: GraphQLOperationType { .query }

  open class var operationName: String { "MockOperationName" }

  open class var document: DocumentType {
    .notPersisted(definition: .init("Mock Operation Definition"))
  }

  open var __variables: Variables?

  public init() {}

}

open class MockQuery<SelectionSet: RootSelectionSet>: MockOperation<SelectionSet>, GraphQLQuery {
  public static func mock() -> MockQuery<MockSelectionSet> where SelectionSet == MockSelectionSet {
    MockQuery<MockSelectionSet>()
  }
}

open class MockMutation<SelectionSet: RootSelectionSet>: MockOperation<SelectionSet>, GraphQLMutation {

  public override class var operationType: GraphQLOperationType { .mutation }

  public static func mock() -> MockMutation<MockSelectionSet> where SelectionSet == MockSelectionSet {
    MockMutation<MockSelectionSet>()
  }
}

open class MockSubscription<SelectionSet: RootSelectionSet>: MockOperation<SelectionSet>, GraphQLSubscription {

  public override class var operationType: GraphQLOperationType { .subscription }

  public static func mock() -> MockSubscription<MockSelectionSet> where SelectionSet == MockSelectionSet {
    MockSubscription<MockSelectionSet>()
  }
}

// MARK: - MockSelectionSets

@dynamicMemberLookup
open class AbstractMockSelectionSet<F, S: SchemaMetadata>: RootSelectionSet, Hashable {
  public typealias Schema = S
  public typealias Fragments = F

  open class var __selections: [Selection] { [] }
  open class var __parentType: ParentType { Object.mock }

  public var __data: DataDict = .empty()

  public required init(_dataDict: DataDict) {
    self.__data = _dataDict
  }

  public subscript<T: AnyScalarType & Hashable>(dynamicMember key: String) -> T? {
    __data[key]
  }

  public subscript<T: MockSelectionSet>(dynamicMember key: String) -> T? {
    __data[key]
  }

  public static func == (lhs: MockSelectionSet, rhs: MockSelectionSet) -> Bool {
    lhs.__data == rhs.__data
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(__data)
  }
}

public typealias MockSelectionSet = AbstractMockSelectionSet<NoFragments, MockSchemaMetadata>

open class MockFragment: MockSelectionSet, Fragment {
  public typealias Schema = MockSchemaMetadata

  open class var fragmentDefinition: StaticString { "" }
}

open class MockTypeCase: MockSelectionSet, InlineFragment {
  public typealias RootEntityType = MockSelectionSet
}

open class ConcreteMockTypeCase<T: MockSelectionSet>: MockSelectionSet, InlineFragment {
  public typealias RootEntityType = T
}

extension DataDict {
  public static func empty() -> DataDict {
    DataDict(data: [:])
  }
}
