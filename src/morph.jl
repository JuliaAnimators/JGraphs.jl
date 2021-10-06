function jgraph_morph(g::JGraph, layout_to, scaling_to; frames = nothing)
    Jnodes = jnodes(g)
    current_positions = g.data.positions
    frames = isnothing(frames) ? g.data.frames : frames
    new_positions = scaling_to * GB2Luxor.(layout_to(g.data.graph))
    for (pos_from, pos_to, node) in zip(current_positions, new_positions, Jnodes)
        act!(node, Action(frames, anim_translate(pos_from, pos_to)))
    end
    g.data.positions = new_positions
end
