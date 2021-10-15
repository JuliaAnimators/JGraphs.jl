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
- `starting_positions` specifies the starting positions of each node, defaults 
to [`get_starting_positions(g)`](@ref)
"""
function jgraph_morph(
    g::JGraph,
    layout_to::Vector{T},
    scaling_to;
    frames = nothing,
    starting_positions = get_starting_positions(g),
) where {T<:NetworkLayout.AbstractLayout}

    frames = isnothing(frames) ? g.data.frames : frames
    frames_stops =
        floor.(Int, range(first(frames) - 1, last(frames), length = length(layout_to) + 1))

    for i in 1:length(layout_to)
        starting_positions = jgraph_morph(
            g,
            layout_to[i],
            scaling_to[i],
            frames = (frames_stops[i] + 1):frames_stops[i + 1],
            starting_positions = starting_positions,
        )
    end
    return starting_positions
end

function jgraph_morph(
    g::JGraph,
    layout_to::NetworkLayout.AbstractLayout,
    scaling_to;
    frames = nothing,
    starting_positions = get_starting_positions(g),
)
    Jnodes = jnodes(g)
    frames = isnothing(frames) ? g.data.frames : frames
    positions = scaling_to .* GB2Luxor.(layout_to(g.data.graph))
    for (node, pos_from, pos_to) in zip(Jnodes, starting_positions, positions)
        act!(node, Action(GFrames(frames), anim_translate(pos_from, pos_to)))
    end
    return positions
end
