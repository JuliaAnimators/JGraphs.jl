function Jmst(g::JGraph, mst_func)
    mst = mst_func(g.data.graph)
    Jnodes = jnodes(g)
    Jedges = jedges(g)
    root = mst[1].src
    step_length = g.data.frames[end] ÷ length(mst)
    for (idx, e) in enumerate(mst)
        color_anim = Animation(
            [0.0, 1.0],
            [Lab(colorant"black"), Lab(colorant"red")],
            [sineio()]
        )
        from = idx-1 * step_length + 1
        to = idx * step_length
        act!(Jnodes[e.src], Action(from:to, color_anim, sethue()))
        act!(Jedges[e.src=>e.dst], Action(from:to, color_anim, sethue()))
        act!(Jnodes[e.dst], Action(from:to, color_anim, sethue()))
    end
end
