"""
    jgraph_morph(g::JGraph, layout_to, scaling_to; frames=nothing)

This functions allows to animate the change from one layout to another for a graph.

# Arguments
- `g::JGraph` the `JGraph` to animate.
- `layout_to` a `NetworkLayout.AbstractLayout` that will be applied to nodes and edges 
to determine the configuration to reach.
- `scaling_to` an scaling factor to scale the positions of nodes and edges in the animation.

# Keywords
- `frames` a range of frames during which the the morph will take place.
If not specified the animation will last as long aas the JGraph itself.
"""
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
