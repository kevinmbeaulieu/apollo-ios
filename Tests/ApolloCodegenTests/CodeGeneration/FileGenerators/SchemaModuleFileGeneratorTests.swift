import XCTest
@testable import ApolloCodegenLib
import ApolloCodegenInternalTestHelpers
import Nimble

class SchemaModuleFileGeneratorTests: XCTestCase {
  let rootURL = URL(fileURLWithPath: CodegenTestHelper.outputFolderURL().path)
  let mockFileManager = MockApolloFileManager(strict: false)

  override func tearDown() {
    CodegenTestHelper.deleteExistingOutputFolder()

    super.tearDown()
  }

  // MARK: - Tests

  func test__generate__givenModuleType_swiftPackageManager_shouldGeneratePackageFile() throws {
    // given
    let fileURL = rootURL.appendingPathComponent("Package.swift")

    let configuration = ApolloCodegen.ConfigurationContext(config: ApolloCodegenConfiguration.mock(
      .swiftPackageManager,
      to: rootURL.path
    ))

    mockFileManager.mock(closure: .createFile({ path, data, attributes in
      // then
      expect(path).to(equal(fileURL.path))

      return true
    }))

    // when
    try SchemaModuleFileGenerator.generate(configuration, fileManager: mockFileManager)

    // then
    expect(self.mockFileManager.allClosuresCalled).to(beTrue())
  }

  func test__generate__givenModuleTypeEmbeddedInTarget_lowercaseSchemaName_shouldGenerateNamespaceFileWithCapitalizedName() throws {
    // given
    let fileURL = rootURL.appendingPathComponent("Schema.graphql.swift")

    let configuration = ApolloCodegen.ConfigurationContext(config: ApolloCodegenConfiguration.mock(
      .embeddedInTarget(name: "MockApplication"),
      schemaNamespace: "schema",
      to: rootURL.path
    ))

    mockFileManager.mock(closure: .createFile({ path, data, attributes in
      // then
      expect(path).to(equal(fileURL.path))

      return true
    }))

    // when
    try SchemaModuleFileGenerator.generate(configuration, fileManager: mockFileManager)

    // then
    expect(self.mockFileManager.allClosuresCalled).to(beTrue())
  }

  func test__generate__givenModuleTypeEmbeddedInTarget_uppercaseSchemaName_shouldGenerateNamespaceFileWithUppercaseName() throws {
    // given
    let fileURL = rootURL.appendingPathComponent("SCHEMA.graphql.swift")

    let configuration = ApolloCodegen.ConfigurationContext(config: ApolloCodegenConfiguration.mock(
      .embeddedInTarget(name: "MockApplication"),
      schemaNamespace: "SCHEMA",
      to: rootURL.path
    ))

    mockFileManager.mock(closure: .createFile({ path, data, attributes in
      // then
      expect(path).to(equal(fileURL.path))

      return true
    }))

    // when
    try SchemaModuleFileGenerator.generate(configuration, fileManager: mockFileManager)

    // then
    expect(self.mockFileManager.allClosuresCalled).to(beTrue())
  }

  func test__generate__givenModuleTypeEmbeddedInTarget_capitalizedSchemaName_shouldGenerateNamespaceFileWithCapitalizedName() throws {
    // given
    let fileURL = rootURL.appendingPathComponent("MySchema.graphql.swift")

    let configuration = ApolloCodegen.ConfigurationContext(config: ApolloCodegenConfiguration.mock(
      .embeddedInTarget(name: "MockApplication"),
      schemaNamespace: "MySchema",
      to: rootURL.path
    ))

    mockFileManager.mock(closure: .createFile({ path, data, attributes in
      // then
      expect(path).to(equal(fileURL.path))

      return true
    }))

    // when
    try SchemaModuleFileGenerator.generate(configuration, fileManager: mockFileManager)

    // then
    expect(self.mockFileManager.allClosuresCalled).to(beTrue())
  }

  func test__generate__givenModuleType_other_shouldNotGenerateFile() throws {
    // given
    let configuration = ApolloCodegen.ConfigurationContext(config: ApolloCodegenConfiguration.mock(
      .other,
      to: rootURL.path
    ))

    mockFileManager.mock(closure: .createFile({ path, data, attributes in
      // then
      fail("Unexpected module file created at \(path)")

      return true
    }))

    // when
    try SchemaModuleFileGenerator.generate(configuration, fileManager: mockFileManager)

    // then
    expect(self.mockFileManager.allClosuresCalled).to(beFalse())
  }
}
