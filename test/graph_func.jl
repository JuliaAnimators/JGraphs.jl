@testset "complete graph" begin

    testvideo = Video(400, 400)
    Background(1:30, ground())
    g = complete_graph(8)
    gd = JGraphData(g, NetworkLayout.Shell(),  width = 100, height = 100)
    jg = JGraph(gd)
    for node in jnodes(jg)
        act!(node, Action(anim_rotate_around(2π, O)))
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
    gd = JGraphData(g, NetworkLayout.Shell(), width = 100, height = 100)
    jg = JGraph(gd)

    jgraph_morph(jg, [NetworkLayout.Spring(), NetworkLayout.Shell()], [(50, 50), (100, 100)])
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

@testset "jgraph_walk" begin
    testvideo = Video(400, 400)
    Background(1:30, ground())
    g = complete_graph(8)
    gd = JGraphData(g, NetworkLayout.Shell(), width = 100, height = 100)
    jg = JGraph(gd)

    jgraph_walk(jg, g -> [vertices(g); 1])
    render(testvideo, tempdirectory = "images", pathname = "")

    for frame_id in [1, 8, 15, 23, 30]
        @test_reference "refs/test_jgraph_walk_$(frame_id).png" load(
            "images/$(lpad(frame_id, 10, "0")).png",
        )
    end

    for image in readdir("images", join = true)
        endswith(image, "png") && rm(image)
    end
end

@testset "jgraph_walk jgraph_morph" begin
    testvideo = Video(400, 400)
    Background(1:100, ground("white", "black"))
    g = barbell_graph(5, 10)
    gd = JGraphData(g, NetworkLayout.Spring(), width = 40, height = 40)
    jg = JGraph(gd)
    jgraph_walk(jg, g -> vertices(g))
    jgraph_morph(jg, NetworkLayout.Shell(), (100, 100))
    render(testvideo, tempdirectory = "images", pathname = "")

    for frame_id in [1, 5, 10, 50, 75, 100]
        @test_reference "refs/test_walk_morph_$(frame_id).png" load(
            "images/$(lpad(frame_id, 10, "0")).png",
        )
    end

    for image in readdir("images", join = true)
        endswith(image, "png") && rm(image)
    end
end
