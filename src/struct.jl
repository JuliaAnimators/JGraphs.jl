mutable struct JGraphData
    graph::AbstractGraph
    layout
    node_templates
    edge_color
    edge_size
    scaling
    frames
    numbered
end

"""
    JGraphData(graph::AbstractGraph, layout::NetworkLayout.AbstractLayout; kwargs...)

The `JGraphData` is the structure used to set all the properties of the graph animation,
the graph itself, its layout and all the options useful to animate it in the appropriate way.
It should be passed to `JGraph` to obtain an animation with the specified properties.
The keyword arguments will increase to increase in the future.

# Arguments 
- `graph::AbstractGraph`: A graph as created with `LightGraphs` and affiliate packages
- `layout::NetworkLayout.AbstractLayout`: A layout as provided by `NetworkLayout` to place the graph nodes in sapce.

# Keywords
- `node_template` provide function that could be used as the function argument of an `Object`
- `edges_color` sets the colors of all edges
- `edges_width` sets the width of all edges
- `scaling` scales the positions of all nodes
- `frames` the frames during which the animations on the graph will last if not specified elsewhere
- `numbered` Defaults to `false` if set to `true` labels the nodes with their number as vertices in the graph.
"""
function JGraphData(
    graph::AbstractGraph,
    layout = NetworkLayout.Shell();
    node_templates = JCircle(O, 3, color="black", action=:fill),
    edge_color = colorant"black",
    edge_size = 1,
    scaling = 20,
    frames = Javis.CURRENT_VIDEO[1].background_frames,
    numbered = false,
)

    return JGraphData(
        graph,
        layout,
        node_templates,
        edge_color,
        edge_size,
        scaling,
        frames,
        numbered,
    )
end


mutable struct JGraph
    data::JGraphData
    jnodes::Vector{Object}
    jedges::Dict{Pair{Int64,Int64},Object}
end

function _JGraph(g::JGraphData)

    points = [g.scaling * GB2Luxor(point) for point in g.layout(g.graph)]

    Jnodes = if isa(g.node_templates, Function)
        [
            Object(:same, g.node_templates, point) for
            point in points
        ]

    elseif length(g.node_templates) == 1
        [
            Object(:same, g.node_templates[1], point) for
            point in points
        ]

    else
        length(g.node_templates) != length(points) &&
            error("Either a single function or one for each node should be provided as node_template")

        [
            Object(:same, node_template, point) for
            (node_template, point) in zip(g.node_templates, points)
        ]
    end

    Jedges = Dict([
        (e.src => e.dst) => Object(
            (args...) -> begin
                setline(g.edge_size)
                line(pos(Jnodes[e.src]), pos(Jnodes[e.dst]), :stroke)
            end,
        ) for e in edges(g.graph)
    ])

    if g.numbered
        for (idx, jnode) in enumerate(Jnodes)
            Object((args...) -> begin
                label(string(idx), :N, pos(jnode))
            end)
        end
    end

    return JGraph(g, Jnodes, Jedges)
end


"""
    JGraph(g::JGraphData)

The `JGraph` structure is the core structure of the package when called
with a `JGraphData` argument creates and `Object` for each node in the graph 
and stores them in `jnodes` and an `Object` for each edge and stores them in `jedges`. 
Note that `jnodes` is a `Vector`, whereas `jedges` is a `Dict` with pairs of nodes (integers) 
as keys.

!!! note 
    Since `JGraph` stores `Object`s it can only be called after a `Video`
    has been initialized look at `Javis` documentation to know all about it.
"""
function JGraph(g)
    _JGraph(g)
end


"""
    jnodes(jg::JGraph)

Accessor function to the `jnodes` stored in a `JGraph`. 
"""
function jnodes(jg::JGraph)
    jg.jnodes
end

"""
    jedges(jg::JGraph)

Accessor function to the `jedges` stored in a `JGraph`. 
"""
function jedges(jg::JGraph)
    jg.jedges
end


"""
    get_starting_positions(g::JGraph)

Returns the positions as obtained using the layout and the graph stored
in `g.data`.
"""
function get_starting_positions(g::JGraph)
    g.data.scaling .* GB2Luxor.(g.data.layout(g.data.graph))
end
