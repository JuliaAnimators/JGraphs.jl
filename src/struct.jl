
mutable struct JGraphData
    graph::AbstractGraph
    layout::NetworkLayout.AbstractLayout
    node_color
    node_size 
    edge_color 
    edge_width 
    scaling
end

function JGraphData(
    graph::AbstractGraph,
    layout::NetworkLayout.AbstractLayout;
    node_color = colorant"black",
    node_size = 3,
    edge_color = colorant"black",
    edge_width = 1,
    scaling = 20,
    )

    return JGraphData(
        graph,
        layout,
        node_color,
        node_size,
        edge_color,
        edge_width,
        scaling,
    )
end