"""
    jgraph_morph(g::JGraph, layout_to, lims_to; frames=nothing)

This functions allows to animate the change from one layout to another for a graph.

# Arguments
- `g::JGraph` the `JGraph` to animate.
- `layout_to` a `NetworkLayout.AbstractLayout` or a `Vector{NetworkLayout.AbstractLayout}` that will be applied to nodes and edges 
to determine the configuration to reach.
- `lims_to` a tuple or a vector of tuples each holding width and height to scale the positions of nodes and edges in the animation.

# Keywords
- `frames` a range of frames during which the morph will take place.
If not specified the animation will last as long aas the JGraph itself.
- `starting_positions` specifies the starting positions of each node, defaults 
to [`get_starting_positions(g)`](@ref)
"""
function jgraph_morph(
    g::JGraph,
    layout_to::Vector,
    lims_to::Vector;
    frames = nothing,
    starting_positions = get_starting_positions(g),
    closed=false,
)

    frames = isnothing(frames) ? g.data.frames : frames
    if closed 
        push!(layout_to, g.data.layout)
        push!(lims_to[1], g.data.width)
        push!(lims_to[2], g.data.height)
    end

    frames_stops =
        floor.(Int, range(first(frames) - 1, last(frames), length = length(layout_to) + 1))
     
    for i in 1:length(layout_to)
        starting_positions = jgraph_morph(
            g,
            layout_to[i],
            lims_to[i],
            frames = (frames_stops[i] + 1):frames_stops[i + 1],
            starting_positions = starting_positions,
        )
    end
    return starting_positions
end

function jgraph_morph(
    g::JGraph,
    layout_to,
    lims_to;
    frames = nothing,
    starting_positions = get_starting_positions(g),
)
    Jnodes = jnodes(g)
    frames = isnothing(frames) ? g.data.frames : frames
    positions = _adapt_to_lims(layout_to(g.data.graph), lims_to...)
    for (node, pos_from, pos_to) in zip(Jnodes, starting_positions, positions)
        act!(node, Action(frames, anim_translate(pos_from, pos_to)))
    end
    return positions
end
