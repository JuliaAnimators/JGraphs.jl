function Jrandom_walk(g::JGraph, random_walk_func)
    Jnodes = jnodes(g)
    Jedges = jedges(g)
    random_walk = random_walk_func(g.data.graph)
    step_length = g.data.frames[end] ÷ length(random_walk)
    color_anim =
        Animation([0.0, 1.0], [Lab(colorant"black"), Lab(colorant"red")], [sineio()])
    acted_nodes = []
    act!(Jnodes[random_walk[1]], Action(1:step_length, color_anim, sethue()))
    for (idx, v) in enumerate(random_walk[2:end])
        from = (idx - 1) * step_length + 1
        to = idx * step_length
        !(v in acted_nodes) && act!(Jnodes[v], Action(from:to, color_anim, sethue()))
        push!(acted_nodes, v)
        if haskey(Jedges, v => random_walk[idx])
            ce = Jedges[v => random_walk[idx]]
            act!(ce, Action(from:to, color_anim, sethue()))
        else
            ce = Jedges[random_walk[idx] => v]
            act!(ce, Action(from:to, color_anim, sethue()))
        end
    end
end
