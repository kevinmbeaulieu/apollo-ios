// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SameHeroTwiceQuery: GraphQLQuery {
  public static let operationName: String = "SameHeroTwice"
  public static let document: ApolloAPI.DocumentType = .automaticallyPersisted(
    operationIdentifier: "2a8ad85a703add7d64622aaf6be76b58a1134caf28e4ff6b34dd00ba89541364",
    definition: .init(
      #"""
      query SameHeroTwice {
        hero {
          __typename
          name
        }
        r2: hero {
          __typename
          appearsIn
        }
      }
      """#
    ))

  public init() {}

  public struct Data: StarWarsAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { StarWarsAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("hero", Hero?.self),
      .field("hero", alias: "r2", R2?.self),
    ] }

    public var hero: Hero? { __data["hero"] }
    public var r2: R2? { __data["r2"] }

    public init(
      hero: Hero? = nil,
      r2: R2? = nil
    ) {
      self.init(_dataDict: DataDict(data: [
        "__typename": StarWarsAPI.Objects.Query.typename,
        "hero": hero._fieldData,
        "r2": r2._fieldData,
        "__fulfilled": Set([
          ObjectIdentifier(Self.self)
        ])
      ]))
    }

    /// Hero
    ///
    /// Parent Type: `Character`
    public struct Hero: StarWarsAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { StarWarsAPI.Interfaces.Character }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("name", String.self),
      ] }

      /// The name of the character
      public var name: String { __data["name"] }

      public init(
        __typename: String,
        name: String
      ) {
        self.init(_dataDict: DataDict(data: [
          "__typename": __typename,
          "name": name,
          "__fulfilled": Set([
            ObjectIdentifier(Self.self)
          ])
        ]))
      }
    }

    /// R2
    ///
    /// Parent Type: `Character`
    public struct R2: StarWarsAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { StarWarsAPI.Interfaces.Character }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("appearsIn", [GraphQLEnum<StarWarsAPI.Episode>?].self),
      ] }

      /// The movies this character appears in
      public var appearsIn: [GraphQLEnum<StarWarsAPI.Episode>?] { __data["appearsIn"] }

      public init(
        __typename: String,
        appearsIn: [GraphQLEnum<StarWarsAPI.Episode>?]
      ) {
        self.init(_dataDict: DataDict(data: [
          "__typename": __typename,
          "appearsIn": appearsIn,
          "__fulfilled": Set([
            ObjectIdentifier(Self.self)
          ])
        ]))
      }
    }
  }
}
