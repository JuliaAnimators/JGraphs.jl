function Jkruskal_mst(g::JGraphData, n_frames)
    Object(JGraph(g))
    points = [g.scaling * JGraphs.GB2Luxor(p) for p in g.layout(g.graph)]
    mst = kruskal_mst(g.graph)
    root = mst[1].src
    step_length = n_frames ÷ length(mst)
    for (idx, e) in enumerate(mst)
        ob = Object(
            (idx * step_length):n_frames,
            @JShape begin
                if e.src == root || e.dst == root
                    sethue("blue")
                    circle(points[e.src], 5, :fill)
                    setline(3)
                    line(points[e.src], points[e.dst], :stroke)
                else
                    sethue("red")
                    circle(points[e.src], 5, :fill)
                    setline(3)
                    line(points[e.src], points[e.dst], :stroke)
                end
                sethue("red")
                circle(points[e.dst], 5, :fill)
            end
        )
        act!(ob, Action(1:step_length, appear(:fade)))
    end
end
