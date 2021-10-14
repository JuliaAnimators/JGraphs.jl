
"""
    GB2Luxor(p)

Transforms a `Point` defined in `GeometryBasics` into one defined 
in `Luxor`.
"""
GB2Luxor(p) = Point(p...)

"""
    draw_node(args; center, radius, action)

Function used to draw a circle. Very similar to `Javis.JCircle` with the only 
difference that it does not use `sethue` so animating a color change is easier.
"""
function draw_node(args...; center, radius, action)
    (args...; center = center, radius = radius, action = action) -> begin
        circle(center, radius, action)
        return center
    end
end
