# Johnson-Lindenstrauss Lemma

# from http://www.johnmyleswhite.com/notebook/2014/03/24/a-note-on-the-johnson-lindenstrauss-lemma/c


mindim(n::Integer, ε::Real) = ceil(Int, (4 * log(n)) / (ε^2 / 2 - ε^3 / 3))

function projection(
    X,
    ε::Real,
    k::Integer = mindim(size(X, 2), ε)
)

    d, n = size(X)
    #=if d != n
        X = _supersize_me(X)  
        k = mindim(size(X, 2), ε)
    end=#
    A = rand(Normal(0,  1 / sqrt(k)), k, d)
    return A, k, A * X
end

function _supersize_me(X, verbose = false)
    d, n = size(X)
    if d > n
        # we need a nxn matrix
        # let's add some empty documents!
        if verbose
            println("reallocating empty mat...")
        end
        new = spzeros(d,d)
        if verbose
            println("repopulating with old values...")
            
        end
        l = length(X.nzval)
        c = 1
        for j in 1:X.n
            for i in X.colptr[j]:(X.colptr[j+1]-1)
                new[j,X.rowval[i]]= X.nzval[i]
                if verbose
                    println("written $c out of $l")
                    c+=1
                end
            end
        end
        if verbose
            println("done")
        end
    elseif d < n
        # we need a nxn matrix
        # let's add some empty words!
        if verbose
            println("reallocating empty mat...")
        end
        new = spzeros(n,n)
        if verbose
            println("repopulating with old values...")
        end
        for j in 1:X.n
            for i in X.colptr[j]:(X.colptr[j+1]-1)
                new[j,X.rowval[i]]= X.nzval[i]
            end
        end
        if verbose
            println("done")
        end      
    end
    new
end

function ispreserved(X, A, ε::Real, verbose = false)
    d, n = size(X)
    k = size(A, 1)
    ret = true
    for i in 1:n
        for j in (i + 1):n
            u, v = X[:, i], X[:, j]
            d_old = norm(u - v)^2
            d_new = norm(A * u - A * v)^2
            if verbose
                println("Considering the pair X[:, $i], X[:, $j]...")
                println("\tOld distance: $d_old")
                println("\tNew distance: $d_new")
                println(
                    "\tWithin bounds $((1 - ε) * d_old) <= $(d_new) <= $((1 + ε) * d_old)")
            end
            if !((1 - ε) * d_old <= d_new <= (1 + ε) * d_old)
                return false
            end
        end
    end

    return true
end

function hell(mat, times=100, ε=0.1, verbose=false)
    min = mindim(size(mat, 2), ε)
    res = projection(mat, ε, min)
    c = 1
    while !(ispreserved(mat, res[1], ε, verbose)) && c < times
        res = projection(mat, ε, min)
        c += 1
        println("try $c")
    end
    if !(c < times)
        println("function failed")
    end
    res
end
