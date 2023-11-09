[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 2
  ny = 2
[]

[Problem]
  solve = true
[]

[Variables]
  [temperature]
    order = FIRST
    family = LAGRANGE
  []
[]

[AuxVariables]
  [p]
    order = FIRST
    family = LAGRANGE
  []
[]

[AuxKernels]
  [pressure]
    type = ParsedAux
    variable = p
    expression = '1e6'
  []
[]

[Kernels]
  [diff]
    type = Diffusion
    variable = temperature
  []
[]

[Materials]
  [Hw]
    type = ADComputeCustomHw
    P = internal_pressure
    fp = water
    pressure = p
  []
[]

[FluidProperties]
  [water]
    type = Water97FluidProperties
  []
[]

[BCs]
  [coolant_temp]
    type = ADCustomHeatFluxBC
    variable = temperature
    boundary = right
    T_sat = T_sat
    heat_transfer_coefficient = Hw_cutom
  []
  [left]
    type = DirichletBC
    variable = temperature
    value = 1000
    boundary = left
  []
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'

[]

[Postprocessors]
  [internal_pressure]
    type = ConstantPostprocessor
    value = 1e5
    execute_on = 'initial'
  []
  [T_sat]
    type = ADElementAverageMaterialProperty
    mat_prop = T_sat
  []
  [T]
    type = SideAverageValue
    variable = temperature
    boundary = right
  []
[]

[Outputs]
  exodus = true
  checkpoint = true
[]

