function Jrandom_walk(g::JGraph, random_walk_func)
    Jnodes = jnodes(g)
    Jedges = jedges(g)
    random_walk = random_walk_func(g.data.graph)
    step_length = g.data.frames[end] ÷ length(random_walk)
    root = random_walk[1]
    color_anim = Animation(
            [0.0, 1.0],
            [Lab(colorant"black"), Lab(colorant"red")],
            [sineio()]
        )

    # act!(root, Action(1:step_length, color_anim, sethue()))
    for (idx, v) in enumerate(random_walk[1:end-1])
        from = idx-1 * step_length + 1
        to = idx * step_length
        act!(Jnodes[v], Action(from:to, color_anim, sethue()))
        if haskey(Jedges, v=>random_walk[idx+1])
            ce = Jedges[v=>random_walk[idx+1]]
            act!(ce, Action(from:to, color_anim, sethue()))
        else
            ce = Jedges[random_walk[idx+1] => v]
            act!(ce, Action(from:to, color_anim, sethue()))
        end
    end
end