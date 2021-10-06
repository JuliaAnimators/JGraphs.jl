using JGraphs
using Javis
using Test
using Images
using VideoIO
using ReferenceTests
using LightGraphs
import NetworkLayout

function ground(c1="white", c2="black")
    (args...) -> begin
        background(c1)
        sethue(c2)
    end
end


@testset "JGraphs.jl" begin
    include("unit.jl")
end
