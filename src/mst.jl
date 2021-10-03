function Jmst(g::JGraphData, mst_func)
    Object(JGraph(g))
    points = [g.scaling * JGraphs.GB2Luxor(p) for p in g.layout(g.graph)]
    mst = mst_func(g.graph)
    root = mst[1].src
    step_length = g.frames[end] ÷ length(mst)
    for (idx, e) in enumerate(mst)
        ob = Object(
            ((idx-1) * step_length) + 1:Javis.CURRENT_VIDEO[1].background_frames[end],
            @JShape begin
                if e.src == root || e.dst == root
                    sethue("blue")
                    circle(points[e.src], 3, :fill)
                    # setline(3)
                    line(points[e.src], points[e.dst], :stroke)
                else
                    sethue("red")
                    circle(points[e.src], 3, :fill)
                    # setline(3)
                    line(points[e.src], points[e.dst], :stroke)
                end
                sethue("red")
                circle(points[e.dst], 3, :fill)
            end
        )
        act!(ob, Action(1:step_length, appear(:fade)))
    end
end
