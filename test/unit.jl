

@testset "draw node" begin

    testvideo = Video(200, 200)
    Background(1:20, ground())
    Object(draw_node(center = Point(50, 50), radius = 20, action = :fill))
    render(testvideo, tempdirectory = "images", pathname = "")

    @test_reference "refs/test_draw_node.png" load("images/$(lpad(5, 10, "0")).png")

    for image in readdir("images", join = true)
        endswith(image, "png") && rm(image)
    end
end

@testset "complete graph" begin

    testvideo = Video(400, 400)
    Background(1:30, ground())
    g = complete_graph(8)
    gd = JGraphData(g, NetworkLayout.Shell(), scaling = 100)
    jg = JGraph(gd)
    for node in jnodes(jg)
        act!(node, Action(anim_rotate(2π)))
    end
    render(testvideo, tempdirectory = "images", pathname = "")

    @test_reference "refs/test_complete_graph_5.png" load("images/$(lpad(5, 10, "0")).png")

    for image in readdir("images", join = true)
        endswith(image, "png") && rm(image)
    end
end

@testset "morph" begin
    testvideo = Video(400, 400)
    Background(1:30, ground())
    g = complete_graph(8)
    gd = JGraphData(g, NetworkLayout.Shell(), scaling = 100)
    jg = JGraph(gd)

    jgraph_morph(jg, NetworkLayout.Spring(), 50, frames = 1:15)
    jgraph_morph(jg, NetworkLayout.Shell(), 100, frames = 16:30)
    render(testvideo, tempdirectory = "images", pathname = "")

    for frame_id in [7, 15, 23, 30]
        @test_reference "refs/test_morph_$(frame_id).png" load(
            "images/$(lpad(frame_id, 10, "0")).png",
        )
    end

    for image in readdir("images", join = true)
        endswith(image, "png") && rm(image)
    end
end
