function GB2Luxor(p)
    Point(p...)
end

function draw_node(args...; center, radius, action)
    (args...; center = center, radius = radius, action = action) -> begin
        circle(center, radius, action)
        return center
    end
end
