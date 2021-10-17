function jadd_vertex!(g::JGraph; starting_frame=1)
    
    add_vertex!(g.data.graph)

    positions = _adapt_to_lims(g.data.layout(g.data.graph), g.data.width, g.data.height)
    
    push!(
        g.jnodes,
        Object(starting_frame:g.data.frames[end], g.data.node_templates, positions[end])
    )
    
    jgraph_morph(g, g.data.layout, (g.data.width, g.data.height), frames=starting_frame:starting_frame)
end