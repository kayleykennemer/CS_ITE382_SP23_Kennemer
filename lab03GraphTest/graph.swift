//
//  graph.swift
//  lab03GraphTest
//
//  Created by Kayley Kennemer on 1/28/23.
//

public protocol Edge: CustomStringConvertible {
    var u: Int {get set}
    var v: Int {get set}
    var reversed: Edge {get}
}

protocol Graph: AnyObject, CustomStringConvertible {
    associatedtype VertexType: Equatable
    associatedtype EdgeType: Edge
    var vertices: [VertexType] {get set}
    var edges: [[EdgeType]] {get set}
}

extension Graph {
    public var vartexCount: Int {return vertices.count}
    
    public var edgeCount: Int {return edges.joined().count }
    
    public func vertexAtIndex(_ index: Int) -> VertexType {
        return vertices[index]
    }
    public func indexOfVertex(_ vertex: VertexType) -> Int? {
        if vertices.firstIndex(of: vertex) != nil {
            return 1
        }
        return nil
    }
    public func neighborsForIndex(_ index: Int) -> [VertexType] {
        return edges[index].map({self.vertices[$0.v]})
    }
    public func neighborsForVertex(_ vertex: VertexType) -> [VertexType]? {
        if let i = indexOfVertex(vertex) {
            return neighborsForIndex(i)
        }
        return nil
    }
    public func edgesForIndex(_ index: Int) -> [EdgeType] {
        return edges[index]
    }
    public func edgesForVertex(_ vertex: VertexType) -> [EdgeType]? {
        if let i = indexOfVertex(vertex) {
            return edgesForIndex(i)
        }
        return nil
    }
    public func addVertex(_ v: VertexType) -> Int {
        vertices.append(v)
        edges.append([EdgeType]())
        return vertices.count - 1
    }
    public func addEdge(_ e: EdgeType) {
        edges[e.u].append(e)
        edges[e.v].append(e.reversed as! EdgeType)
    }
}

open class UnweightedEdge: Edge {
    public var u: Int
    public var v: Int
    public var reversed: Edge {
        return UnweightedEdge (u: v, v: u)
    }
    
    public init(u: Int, v: Int) {
        self.u = u
        self.v = v
    }
    
    public var description: String {
        return "\(u) <-> \(v)"
    }
}

open class UnweightedGraph <V: Equatable>: Graph {
    
    var vertices = [V]()
    var edges: [[UnweightedEdge]] = [[UnweightedEdge]]()
    
    public init(vertices: [V]) {
        for vertex in vertices {
            _ = self.addVertex(vertex)
        }
    }
    
    public func addEdge(from: Int, to: Int) {
        addEdge(UnweightedEdge(u: from, v: to))
    }
    
    public func addEdge(from: V, to: V) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                addEdge(UnweightedEdge(u: u, v: v))
            }
        }
    }
    
    public var description: String {
        var d: String = " "
        for i in O..<vertices.count {
            d += "\(vertices[i] -> \(neighborsForIndex(i)),\n)"
        }
        return d
    }
}


var cityGraph: UnweightedGraph<String> = UnweightedGraph<String>(vertices: ["Seattle", "San Francisco", "Los Angeles", "Riverside", "Phoenix", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston", "Detroit", "Philadelphia", "Washington"])

@main {
    print("Let's try building an unweighted graph")
    
    cityGraph.addEdge(from: "Seattle", to: "Chicago")
    cityGraph.addEdge(from: "Seattle", to: "San Francisco")
    cityGraph.addEdge(from: "San Francisco", to: "Riverside")
    cityGraph.addEdge(from: "San Francisco", to: "Los Angeles")
    cityGraph.addEdge(from: "Los Angeles", to: "Riverside")
    cityGraph.addEdge(from: "Los Angeles", to: "Phoenix")
    cityGraph.addEdge(from: "Riverside", to: "Phoenix")
    cityGraph.addEdge(from: "Phoenix", to: "Dallas")
    cityGraph.addEdge(from: "Phoenix", to: "Houston")
    cityGraph.addEdge(from: "Dallas", to: "Chicago")
    cityGraph.addEdge(from: "Dallas", to: "Atlanta")
    cityGraph.addEdge(from: "Dallas", to: "Houston")
    cityGraph.addEdge(from: "Houston", to: "Atlanta")
    cityGraph.addEdge(from: "Houston", to: "Miami")
    cityGraph.addEdge(from: "Atlanta", to: "Chicago")
    cityGraph.addEdge(from: "Atlanta", to: "Washington")
    cityGraph.addEdge(from: "Atlanta", to: "Miami")
    cityGraph.addEdge(from: "Miami", to: "Washington")
    cityGraph.addEdge(from: "Chicago", to: "Detroit")
    cityGraph.addEdge(from: "Detroit", to: "Boston")
    cityGraph.addEdge(from: "Detroit", to: "Washington")
    cityGraph.addEdge(from: "Detroit", to: "New York")
    cityGraph.addEdge(from: "Boston", to: "New York")
    cityGraph.addEdge(from: "New York", to: "Philadelphia")
    cityGraph.addEdge(from: "Philadelphia", to: "Washington")

    print(cityGraph)
}
    


