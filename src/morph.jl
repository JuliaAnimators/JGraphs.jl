"""
    jgraph_morph(g::JGraph, layout_to, scaling_to; frames=nothing)

This functions allows to animate the change from one layout to another for a graph.

# Arguments
- `g::JGraph` the `JGraph` to animate.
- `layout_to` a `NetworkLayout.AbstractLayout` or a `Vector{NetworkLayout.AbstractLayout}` that will be applied to nodes and edges 
to determine the configuration to reach.
- `scaling_to` a scaling factor or a vector of scaling factors to scale the positions of nodes and edges in the animation.

# Keywords
- `frames` a range of frames during which the the morph will take place.
If not specified the animation will last as long aas the JGraph itself.
"""
function jgraph_morph(
    g::JGraph,
    layout_to::Vector{T},
    scaling_to;
    frames = nothing,
) where {T<:NetworkLayout.AbstractLayout}
    length(layout_to) <= 1 &&
        error("For a single layout don't use a vector but the layout itself as argument.")
    Jnodes = jnodes(g)
    frames = isnothing(frames) ? g.data.frames : frames
    positions = [
        scale .* GB2Luxor.(lay(g.data.graph)) for (lay, scale) in zip(layout_to, scaling_to)
    ]
    for (node, args...) in zip(Jnodes, positions...)
        act!(node, Action(frames, follow_path([i for i in args], closed = false)))
    end
    return g
end

function jgraph_morph(
    g::JGraph,
    layout_to::NetworkLayout.AbstractLayout,
    scaling_to;
    frames = nothing,
)
    Jnodes = jnodes(g)
    frames = isnothing(frames) ? g.data.frames : frames
    positions = scaling_to .* GB2Luxor.(layout_to(g.data.graph))
    for (node, pos_to) in zip(Jnodes, positions)
        act!(node, Action(frames, anim_translate(pos_to...)))
    end
    return g
end
