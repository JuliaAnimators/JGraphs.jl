
"""
    jmst(g::JGraph, mst_func)

Function used to animate the appearance of a minimum spannin tree
on a `JGraph`.

# Arguments
- `g::JGraph` the `JGraph` to use for the animation.
- `mst_func` a function that takes an `AbstractGraph` as an arguments and
return a list of `edge`s as defined in `LightGraphs`. One can use `kruskal_mst` 
and `prim_mst` defined in `LightGraphs`. 
"""

function jmst(g::JGraph, mst_func)
    mst = mst_func(g.data.graph)
    Jnodes = jnodes(g)
    Jedges = jedges(g)
    step_length = g.data.frames[end] ÷ length(mst)
    color_anim =
        Animation([0.0, 1.0], [Lab(colorant"black"), Lab(colorant"red")], [sineio()])
    acted_nodes = []
    for (idx, e) in enumerate(mst)
        from = (idx - 1) * step_length + 1
        to = idx * step_length

        !(e.src in acted_nodes) &&
            act!(Jnodes[e.src], Action(from:to, color_anim, sethue()))
        push!(acted_nodes, e.src)

        !(e.dst in acted_nodes) &&
            act!(Jnodes[e.dst], Action(from:to, color_anim, sethue()))
        push!(acted_nodes, e.dst)

        if haskey(Jedges, e.src => e.dst)
            act!(Jedges[e.src => e.dst], Action(from:to, color_anim, sethue()))
        else
            act!(Jedges[e.dst => e.src], Action(from:to, color_anim, sethue()))
        end
    end
end
