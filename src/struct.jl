mutable struct JGraphData
    graph::AbstractGraph
    layout::NetworkLayout.AbstractLayout
    node_color
    node_size
    edge_color
    edge_width
    scaling
    frames
    numbered
    positions
end

"""
    JGraphData(graph::AbstractGraph, layout::NetworkLayout.AbstractLayout; kwargs...)

The `JGraphData` is the structure used to set all the properties of the graph Animation,
the graph itself, its layout and all the properties useful to animate it in the appropriate way.
It should be passed to `JGraph` to obtain an animation with the specified properties.
The keyword arguments are supposed to increase in the future.

# Arguments 
- `graph::AbstractGraph`: A graph as created with `LightGraphs` and affiliate packages
- `layout::NetworkLayout.AbstractLayout`: A layout as provided by `NetworkLayout` to place the 
graph nodes in sapce.

# Keywords
- `node_color` sets the color of all nodes
- `node_size` sets the size of all nodes
- `edges_color` sets the colors of all edges
- `edges_width` sets the width of all edges
- `scaling` scales the positions of all nodes
- `frames` the frames during which the animations on the graph will last if not specified elsewhere
- `numbered` Defaults to `false` if set to `true` labels the nodes with their number as vertices 
in the graph.
"""
function JGraphData(
    graph::AbstractGraph,
    layout::NetworkLayout.AbstractLayout = NetworkLayout.Shell();
    node_color = colorant"black",
    node_size = 3,
    edge_color = colorant"black",
    edge_width = 1,
    scaling = 20,
    frames = first(Javis.CURRENT_VIDEO[1].background_frames):last(
        Javis.CURRENT_VIDEO[1].background_frames,
    ),
    numbered = false,
    positions = Luxor.Point[],
)

    return JGraphData(
        graph,
        layout,
        node_color,
        node_size,
        edge_color,
        edge_width,
        scaling,
        frames,
        numbered,
        positions,
    )
end

"""
    JGraph(g::JGraphData)

The `JGraph` structure is the core structure of the package when called
with a `JGraphData` argument creates and `Object` for each node in the graph 
and stores them in `jnodes` and an `Object` for each edge and stores them in `jedges`. 
Note that the nodes are stored in a `Vector`, whereas the edges are stored in a `Dict` 
with pairs of nodes (integers) as keys.

***Note*** Since `JGraph` stores `Object`s it can only be called after a `Video`
has been initialized look at `Javis` documentation to know all about it.
"""
mutable struct JGraph
    data::JGraphData
    jnodes::Vector{Object}
    jedges::Dict{Pair{Int64,Int64},Object}
end

function _JGraph(g::JGraphData)

    points = [g.scaling * GB2Luxor(point) for point in g.layout(g.graph)]

    g.positions = points

    Jnodes = [
        Object(draw_node(center = point, radius = g.node_size, action = :fill)) for
        point in points
    ]

    Jedges = Dict([
        (e.src => e.dst) => Object(
            (args...) -> begin
                setline(g.edge_width)
                line(pos(Jnodes[e.src]), pos(Jnodes[e.dst]), :stroke)
            end,
        ) for e in edges(g.graph)
    ])

    if g.numbered
        for (idx, jnode) in enumerate(Jnodes)
            Object((args...) -> begin
                label(string(idx), :N, pos(Jnode))
            end)
        end
    end

    return JGraph(g, Jnodes, Jedges)
end



function JGraph(g)
    _JGraph(g)
end


"""
    jnodes(jg::JGraph)

Accessor function to get access to the `jnodes` stored in a `JGraph`. 
"""
jnodes(Jg::JGraph) = Jg.nodes

"""
    jedges(jg::JGraph)

Accessor function to get access to the `jedges` stored in a `JGraph`. 
"""
jedges(Jg::JGraph) = Jg.edges
