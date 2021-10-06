function graph_morph(g::JGraph, current_positions, layout_to, scaling_to)
    Jnodes = jnodes(g)
    new_positions = scaling_to * GB2Luxor.(layout_to(g.data.graph))
    for (pos_from, pos_to, node) in zip(current_positions, new_positions, Jnodes)
        act!(node, Action(g.data.frames, anim_translate(pos_from, pos_to)))
        # act!(node, Action(change(:center, pos_to)))
    end 
end