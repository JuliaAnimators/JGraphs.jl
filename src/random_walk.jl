"""
    jgraph_walk(g::JGraph, walk_func)

This function will iteratively change the colors of nodes and edges in a graph
to draw a path along them of the graph.

# Arguments
- `g::JGraph` the `JGraph` on which the walk should be animated
- `walk_func` a function that takes as argument and `AbstractGraph` and returns
a set of nodes linked each to the following one by and edge present in the graph.
One can use `randomwalk` and `non_backtracking_randomwalk` from `LightGraphs`.
"""
function jgraph_walk(g::JGraph, walk_func)
    Jnodes = jnodes(g)
    Jedges = jedges(g)
    random_walk = walk_func(g.data.graph)
    step_length = g.data.frames[end] ÷ length(random_walk)
    color_anim =
        Animation([0.0, 1.0], [Lab(colorant"black"), Lab(colorant"red")], [sineio()])
    acted_nodes = []
    acted_edges = []
    act!(Jnodes[random_walk[1]], Action(1:step_length, change(:color, colorant"black"=>colorant"red")))
    for (idx, v) in enumerate(random_walk[2:end])
        from = (idx - 1) * step_length + 1
        to = idx * step_length
        !(v in acted_nodes) && act!(Jnodes[v], Action(from:to, change(:color, colorant"black"=>colorant"red")))
        push!(acted_nodes, v)
        if haskey(Jedges, v => random_walk[idx]) && !in(v => random_walk[idx], acted_edges)
            ce = Jedges[v => random_walk[idx]]
            push!(acted_edges, ce)
            act!(ce, Action(from:to, color_anim, sethue()))
        elseif !in(v => random_walk[idx], acted_edges)
            ce = Jedges[random_walk[idx] => v]
            push!(acted_edges, ce)
            act!(ce, Action(from:to, color_anim, sethue()))
        end
    end
end
