function find_equal_rows(mat)
    #mat is sparse
    # get rev mat
    mat = flip_mat(mat)

    sparr = get_sparse_arrays(mat)

    
    

    



end
"""
turns a nxm sparse matrix into a mxn sparse matrix, switching rows with columns in O(x) time, where x = number of stored values
"""
function flip_mat(mat)
    res = spzeros(mat.n, mat.m)
    for j in 1:mat.n
        for i in mat.colptr[j]:(mat.colptr[j+1]-1)
            res[j,mat.rowval[i]]= mat.nzval[i]
        end
    end    
    res
end

function get_sparse_arrays(mat)
    res = Array{SparseVector{Float64,Int64},1}(undef, mat.n)

    for j in 1:mat.n
        res[j] = mat[:,j]
    end
    res
end 

function find_equal_sparse_arrays(sparr)
    #two sparse arrays can be the same only if they have the same number of nonzero values
    lengths = [length(x.nzind) for x in sparr]
    spr_sort = sortperm(lengths)

    res = []
    memory = spr_sort[1]
    tmp = []
    for i in spr_sort
    end

end






#=
struct SparseMatrixCSC{Tv,Ti<:Integer} <: AbstractSparseMatrixCSC{Tv,Ti}
    m::Int                  # Number of rows
    n::Int                  # Number of columns
    colptr::Vector{Ti}      # Column j is in colptr[j]:(colptr[j+1]-1)
    rowval::Vector{Ti}      # Row indices of stored values
    nzval::Vector{Tv}       # Stored values, typically nonzeros
end
=#