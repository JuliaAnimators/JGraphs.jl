mutable struct JGraphData
    graph::AbstractGraph
    layout::NetworkLayout.AbstractLayout
    node_color
    node_size
    edge_color
    edge_width
    scaling
    frames
end

function JGraphData(
    graph::AbstractGraph,
    layout::NetworkLayout.AbstractLayout;
    node_color = colorant"black",
    node_size = 3,
    edge_color = colorant"black",
    edge_width = 1,
    scaling = 20,
    frames = Javis.CURRENT_VIDEO[1].background_frames
)

    return JGraphData(graph, layout, node_color, node_size, edge_color, edge_width, scaling, frames)
end

mutable struct JGraph
    data::JGraphData
    nodes::Vector{Object}
    edges::Dict{Pair{Int64, Int64}, Object}
end

function _JGraph(g::JGraphData)

    points = [g.scaling * GB2Luxor(point) for point in g.layout(g.graph)]

    Jnodes = [Object(JCircle(point, g.node_size, action=:fill,color=g.node_color)) for point in points]

    Jnodes = [Object((args...)-> begin 
        circle(point, g.node_size, :fill)
        point
    end
    )
    for point in points]
    
            

    Jedges = Dict([
        (e.src => e.dst) => Object((args...) -> begin
            setline(g.edge_width)
            line(pos(Jnodes[e.src]), pos(Jnodes[e.dst]), :stroke)
        end) for e in edges(g.graph)
    ])

    return JGraph(g, Jnodes, Jedges)
end

function JGraph(g)
    _JGraph(g)
end

jnodes(Jg::JGraph) = Jg.nodes
jedges(Jg::JGraph) = Jg.edges
