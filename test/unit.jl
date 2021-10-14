


@testset "tmpdir" begin

    #=
    Leftover files from failed tests or errors can cause testing errors.
    Therefore, we remove any files in the `images` directory not pertinent to testing before executing a test.
    =#

    EXCLUDE_FILES = [".keep"]
    for f in readdir("images")
        !(f in EXCLUDE_FILES) && rm("images/$f")
    end
    @test length(readdir("images")) == length(EXCLUDE_FILES)
end

@testset "util" begin

    testvideo = Video(200, 200)
    Background(1:20, ground())
    Object(draw_node(center = Point(50, 50), radius = 20, action = :fill))
    render(testvideo, tempdirectory = "images", pathname = "")

    @test_reference "refs/test_draw_node.png" load("images/$(lpad(5, 10, "0")).png")

    for image in readdir("images", join = true)
        endswith(image, "png") && rm(image)
    end

    @test GB2Luxor(GeometryBasics.Point(10, 10)) == Point(10, 10)
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

    # jgraph_morph(jg, NetworkLayout.Spring(), 50, frames = 1:15)
    # jgraph_morph(jg, NetworkLayout.Shell(), 100, frames = 16:30)
    jgraph_morph(jg, [NetworkLayout.Spring(), NetworkLayout.Shell()], [50, 100])
    render(testvideo, tempdirectory = "images", pathname = "")

    for frame_id in [7, 15, 23, 30]
        # @test_reference "refs/test_morph_$(frame_id).png" load(
        #     "images/$(lpad(frame_id, 10, "0")).png",
        # )
    end

    for image in readdir("images", join = true)
        endswith(image, "png") && rm(image)
    end
end

@testset "jgraph_walk" begin
    testvideo = Video(400, 400)
    Background(1:30, ground())
    g = complete_graph(8)
    gd = JGraphData(g, NetworkLayout.Shell(), scaling = 100)
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
    gd = JGraphData(g, NetworkLayout.Spring(), scaling = 40)
    jg = JGraph(gd)
    jgraph_walk(jg, g -> vertices(g))
    jgraph_morph(jg, NetworkLayout.Shell(), 100)
    render(testvideo, tempdirectory = "images", pathname = "")

    for frame_id in [1, 5, 10, 50, 75, 100]
        # @test_reference "refs/test_walk_morph_$(frame_id).png" load(
        #     "images/$(lpad(frame_id, 10, "0")).png",
        # )
    end

    for image in readdir("images", join = true)
        endswith(image, "png") && rm(image)
    end
end
