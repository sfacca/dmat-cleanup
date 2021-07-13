# Johnson-Lindenstrauss Lemma

# from http://www.johnmyleswhite.com/notebook/2014/03/24/a-note-on-the-johnson-lindenstrauss-lemma/c


mindim(n::Integer, ε::Real) = ceil(Int, (4 * log(n)) / (ε^2 / 2 - ε^3 / 3))

function projection(
    X,
    ε::Real,
    k::Integer = mindim(size(X, 2), ε)
)
    d, n = size(X)
    A = rand(Normal(1 / sqrt(k)), k, d)
    return A, k, A * X
end

function ispreserved(X, A, ε::Real)
    d, n = size(X)
    k = size(A, 1)

    for i in 1:n
        for j in (i + 1):n
            u, v = X[:, i], X[:, j]
            d_old = norm(u - v)^2
            d_new = norm(A * u - A * v)^2
            println("Considering the pair X[:, %d], X[:, %d]...\n", i, j)
            println("\tOld distance: %f\n", d_old)
            println("\tNew distance: %f\n", d_new)
            println(
                "\tWithin bounds %f <= %f <= %f\n",
                (1 - ε) * d_old,
                d_new,
                (1 + ε) * d_old
            )
            if !((1 - ε) * d_old <= d_old <= (1 + ε) * d_old)
                return false
            end
        end
    end

    return true
end