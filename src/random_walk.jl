function Jrandom_walk(g::JGraphData, random_walk_func)
    Object(JGraph(g))
    points = [g.scaling * JGraphs.GB2Luxor(p) for p in g.layout(g.graph)]
    random_walk = random_walk_func(g.graph)
    step_length = g.frames[end] ÷ length(random_walk)
    root = random_walk[1]
    for (idx, e) in enumerate(random_walk)
        ob = Object(
            ((idx-1) * step_length) + 1:Javis.CURRENT_VIDEO[1].background_frames[end],
            @JShape begin
                if e == root 
                    sethue("blue")
                    circle(points[e], 5, :fill)
                else
                    sethue("red")
                    circle(points[e], 5, :fill)
                    setline(3)
                    line(points[e], points[random_walk[idx-1]], :stroke)
                end
            end
        )
        act!(ob, Action(1:step_length, appear(:fade)))
    end
end