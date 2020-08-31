module MonteCarlo

using Reexport
# Loading the RNG will fail if Random is nto exported
@reexport using MonteCarloObservable, Random
import MonteCarloObservable.AbstractObservable
using StableDQMC, LightXML, Parameters, Requires
using JLD, TimerOutputs
using LoopVectorization, RecursiveFactorization

using Printf, SparseArrays, LinearAlgebra, Dates, Statistics

include("helpers.jl")
include("inplace_udt.jl")
export enable_benchmarks, disable_benchmarks, print_timer, reset_timer!
include("flavors/abstract.jl")
include("models/abstract.jl")
include("lattices/abstract.jl")

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
include("../test/testfunctions.jl")

export reset!
export run!, resume!, replay!
export IsingModel
export HubbardModelAttractive
export MC
export DQMC
export greens

function __init__()
    @require LatPhysBase="eec5c15a-e8bd-11e8-0d23-6799ca40c963" include("lattices/LatPhys.jl")
end

end # module
