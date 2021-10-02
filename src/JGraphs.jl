module JGraphs

using Javis
using LightGraphs
using Colors

import NetworkLayout


export JGraph
export JGraphData


# Write your package code here.
include("util.jl")
include("struct.jl")

function _JGraph(g::JGraphData)

    points = [scaling * GB2Luxor(point) for point in layout(g.graph)]
    sethue(node_color)
    for point in points
        circle(point, g.node_size, :fill)
    end
    for e in edges(g.graph)
        sethue(g.edge_color)
        setline(g.edge_width)
        line(points[e.src], points[e.dst], :stroke)
    end
    g
end


function JGraph(
    graph,
    layout,
    node_color = colorant"black",
    node_size = 3,
    edge_color = colorant"black",
    edge_width = 1,
    scaling = 20,
)
    g = JGraphData(
        graph,
        layout,
        node_color,
        node_size,
        edge_color,
        edge_width,
        scaling,
    )
    return (args...) ->
        _JGraph(g)
end

end #module
