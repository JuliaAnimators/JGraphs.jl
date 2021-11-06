


@testset "tmpdir" begin

    #=
    TAKEN FROM JAVIS
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


