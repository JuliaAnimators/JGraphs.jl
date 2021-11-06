using JGraphs
using Javis
using Test
using Images
using VideoIO
using ReferenceTests
using LightGraphs
import NetworkLayout
import GeometryBasics

function ground(c1 = "white", c2 = "black")
    (args...) -> begin
        background(c1)
        sethue(c2)
    end
end


@testset "JGraphs.jl" begin
    @testset "Unit" begin
        include("unit.jl")
    end
    @testset "graph_func" begin
        include("graph_func.jl")
    end
    @testset "final_clean" begin
        for image in readdir("images", join = true)
            endswith(image, "png") && rm(image)
        end
        @test readdir("images") == [".keep"]
    end
end
