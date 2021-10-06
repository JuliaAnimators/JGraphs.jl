function GB2Luxor(p)
    Point(p...)
end

function draw_node(args...; center, radius, action)
    (args...) -> begin
        circle(center, radius, action)
        return center
    end
end