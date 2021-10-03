module JGraphs

using Javis
using LightGraphs
using Colors

import NetworkLayout


export JGraph, JGraphData

include("util.jl")
include("struct.jl")

include("mst.jl")
export Jkruskal_mst

include("random_walk.jl")
export Jrandom_walk


# Write your package code here.


function _JGraph(g::JGraphData)

    points = [g.scaling * GB2Luxor(point) for point in g.layout(g.graph)]
    sethue(g.node_color)
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

function JGraph(g)
    return (args...) -> _JGraph(g)
end

end #module
