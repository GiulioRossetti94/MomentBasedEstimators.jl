######################################################
### This test implements example 13.5 in Greene (2012)
######################################################

# this is the data from Example C.1 in Greene 2012
income_data = [20.5, 31.5, 47.7, 26.2, 44, 8.28, 30.8, 17.2, 19.9, 9.96,
               55.8, 25.2, 29, 85.5, 15.1, 28.5, 21.4, 17.7, 6.42, 84.9]


## FIXME: 
## Ugly, but see ForwardDiff.j issue #78
## https://github.com/JuliaDiff/ForwardDiff.jl/issues/78

function g_gamma(θ)
    P, λ = [θ[1]], [θ[2]]
    hcat(income_data .- P ./ λ,
         income_data.^2 .- P.*(P .+ 1) ./ (λ.^2),
         log(income_data) .+ log(λ) .- digamma(P),
         1./income_data .- λ./(P .- 1))
end

two_step = GMMEstimator(g_gamma, [2.40, 0.08], initialW = eye(4),  mgr=TwoStepGMM())

MomentBasedEstimators.setparLB!(two_step, [0.0, 0.0])
MomentBasedEstimators.setparUB!(two_step, [+Inf, +Inf])

estimate!(two_step)
