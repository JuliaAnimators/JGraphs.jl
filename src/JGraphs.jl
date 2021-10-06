module JGraphs

using Javis
using LightGraphs
using Colors
using Animations

import NetworkLayout

include("util.jl")
include("struct.jl")
export JGraph, JGraphData, JGraphContainer
export Jnodes, Jedges

include("mst.jl")
export Jmst

include("random_walk.jl")
export Jrandom_walk

end #module
