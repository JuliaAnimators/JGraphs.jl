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

    # TODO add color palette for sequential coloring of repeatedly transversed edges
    Jnodes = jnodes(g)
    Jedges = jedges(g)
    random_walk = walk_func(g.data.graph)
    step_length = g.data.frames[end] ÷ length(random_walk)
    acted_nodes = Dict()
    acted_edges = Dict()
    act!(Jnodes[random_walk[1]], Action(1:step_length, change(:color, colorant"black"=>colorant"red")))
    for (idx, v) in enumerate(random_walk[2:end])
        from = (idx - 1) * step_length + 1
        to = idx * step_length

        if !haskey(acted_nodes, v) 
            act!(Jnodes[v], Action(from:to, change(:color, colorant"black"=>colorant"red")))
            acted_nodes[v] = 1
        else
            act!(Jnodes[v], Action(from:to, change(:color, colorant"red"=>colorant"red")))
            acted_nodes[v] += 1
        end

        ce = if haskey(Jedges, v => random_walk[idx])
            v => random_walk[idx]
        else
            random_walk[idx] => v
        end

        if  !haskey(acted_edges, ce)
            act!(Jedges[ce], Action(from:to, change(:color, colorant"black"=>colorant"red")))
            acted_edges[ce] = 1
        else
            act!(Jedges[ce], Action(from:to, change(:color, colorant"red"=>colorant"red")))
            acted_edges[ce] += 1
        end
    end
end
