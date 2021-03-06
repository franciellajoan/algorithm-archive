type Point
    x::Float64
    y::Float64
end

function ccw(a::Point, b::Point, c::Point)
    return ((b.x - a.x)*(c.y - a.y) - (b.y - a.y)*(c.x - a.x))
end

function graham_scan(points::Vector{Point})
    N = length(points)

    # Place the lowest point at the start of the array
    sort!(points, by = item -> item.y)

    # Sort all other points according to angle with that point
    other_points = sort(points[2:end], by = item -> atan2(item.y - points[1].y,
                                                          item.x - points[1].x))

    # Place points sorted by angle back into points vector
    for i in 1:length(other_points)
        points[i+1] = other_points[i]
    end

    # M will be the point on the hull
    M = 2
    i = 3
    for i = 1:N
        while (ccw(points[M-1], points[M], points[i]) <= 0)
            if (M > 2)
                M -= 1
            # All points are collinear
            elseif (i == N)
                break
            else
                i += 1
            end
        end

        # ccw point found, updating hull and swapping points
        M += 1
        points[i], points[M] = points[M], points[i]
    end

    return points[1:M]
end

function main()
    # This hull is just a simple test so we know what the output should be
    points = [Point(2,1.9), Point(1, 1), Point(2, 4), Point(3, 1), Point(2, 0)]
    hull = graham_scan(points)
    println(hull)
end

main()

