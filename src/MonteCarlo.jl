module MonteCarlo

using Reexport
# Loading the RNG will fail if Random is nto exported
@reexport using MonteCarloObservable, Random
import MonteCarloObservable.AbstractObservable
using Parameters, Requires
using TimerOutputs
using LoopVectorization, RecursiveFactorization
using Printf, SparseArrays, LinearAlgebra, Dates, Statistics


import JLD, JLD2
# To allow switching between JLD and JLD2:
const UnknownType = Union{JLD.UnsupportedType, JLD2.UnknownType}
const JLDFile = Union{JLD.JldFile, JLD2.JLDFile}
jldload(args...; kwargs...) = JLD.load(args...; kwargs...)
function jld2load(args...; kwargs...)
    flatdict = JLD2.FileIO.load(args...; kwargs...)
    # Rebuild structure from JLD
    output = Dict{String, Any}()
    for (k, v) in flatdict
        dict = output
        dirs = splitpath(k)
        for dir in dirs[1:end-1]
            haskey(dict, dir) || (dict[dir] = Dict{String, Any}())
            dict = dict[dir]
        end
        dict[dirs[end]] = v
    end
    output
end


include("helpers.jl")
include("inplace_udt.jl")
export enable_benchmarks, disable_benchmarks, print_timer, reset_timer!
include("flavors/abstract.jl")
include("models/abstract.jl")
include("lattices/abstract.jl")

include("configurations.jl")
include("Measurements.jl")
export measurements, observables

include("lattices/masks.jl")
include("lattices/square.jl")
include("lattices/chain.jl")
include("lattices/cubic.jl")
include("lattices/honeycomb.jl")
include("lattices/triangular.jl")
include("lattices/ALPS.jl")

include("flavors/MC/MC.jl")
include("flavors/DQMC/DQMC.jl")
export uniform_fourier

include("models/Ising/IsingModel.jl")
include("models/HubbardAttractive/HubbardModelAttractive.jl")

include("FileIO.jl")
export save, load, resume!
# include("../test/testfunctions.jl")

export reset!
export run!, resume!, replay!
export IsingModel
export HubbardModelAttractive
export MC
export DQMC
export greens

function __init__()
    @require LatPhysBase="eec5c15a-e8bd-11e8-0d23-6799ca40c963" include("lattices/LatPhys.jl")
    @require LightXML = "9c8b4983-aa76-5018-a973-4c85ecc9e179" include("lattices/ALPS.jl")
end

end # module
