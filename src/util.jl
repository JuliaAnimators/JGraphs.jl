
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

"""
    _adapt_to_lims(points, width, height)

Rescales a vector of points to fit in height and width to keep it simple
it uses the smallest among x and y needed variation to rescale both.
"""
function _adapt_to_lims(points, width, height)
    xs = [p[1] for p in points]
    ys = [p[2] for p in points]
    
    xmin, xmax = abs(minimum(xs)), abs(maximum(xs))
    ymin, ymax = abs(minimum(ys)), abs(maximum(ys))

    xscaling = min(width / 2xmin, width / 2xmax)
    yscaling = min(height / 2ymin, height / 2ymax)
    
    scaling = min(xscaling, yscaling)

    return [Point(p[1] * scaling, p[2] * scaling) for p in points]
end