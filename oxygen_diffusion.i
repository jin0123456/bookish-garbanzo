[GlobalParams]
  order = FIRST
  family = LAGRANGE
[]

[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 1000
    ny = 1
    xmin = 0
    xmax = 0.57
    ymin = 0.0
    ymax = 0.2
    elem_type = QUAD4
  []
[]

[XFEM]
  qrule = volfrac
  output_cut_plane = true
  debug_output_level = 2
[]

[UserObjects]
  [velocity_phi1]
    type = XFEMPhaseTransitionMovingInterfaceVelocity
    diffusivity_at_positive_level_set = 1.18e-4
    diffusivity_at_negative_level_set = 8.5e-6
    equilibrium_concentration_jump = 0.326
    value_at_interface_uo = value_uo_phi1
  []
  [value_uo_phi1]
    type = NodeValueAtXFEMInterface
    variable = 'u'
    interface_mesh_cut_userobject = 'cut_mesh_phi1'
    execute_on = TIMESTEP_END
    level_set_var = phi1
  []
  [cut_mesh_phi1]
    type = InterfaceMeshCut2DUserObject
    mesh_file = ZrO2_alpha.e
    interface_velocity_uo = velocity_phi1
    heal_always = true
  []
  [cut1]
    type = LevelSetCutUserObject
    level_set_var = phi1
    negative_id = 1
    positive_id = 33
    execute_on = NONE
  []
  [velocity_phi2]
    type = XFEMPhaseTransitionMovingInterfaceVelocity
    diffusivity_at_positive_level_set = 8.5e-6
    diffusivity_at_negative_level_set = 1.83e-4
    equilibrium_concentration_jump = 0.0679
    value_at_interface_uo = value_uo_phi2
  []
  [value_uo_phi2]
    type = NodeValueAtXFEMInterface
    variable = 'u'
    interface_mesh_cut_userobject = 'cut_mesh_phi2'
    execute_on = TIMESTEP_END
    level_set_var = phi2
  []
  [cut_mesh_phi2]
    type = InterfaceMeshCut2DUserObject
    mesh_file = alpha_beta.e
    interface_velocity_uo = velocity_phi2
    heal_always = true
  []
  [cut2]
    type = LevelSetCutUserObject
    level_set_var = phi2
    negative_id = 5
    positive_id = 16
    execute_on = NONE
  []
  [combo]
    type = ComboCutUserObject
    geometric_cut_userobjects = 'cut1 cut2'
    cut_subdomain_combinations = '33 16;
                                  33 5;
                                  1 16;
                                  1 5'
    cut_subdomains = '1 3 5 7'
    heal_always = true
  []
[]

[Variables]
  [u]
  []
[]

[ICs]
  [ic_u]
    type = FunctionIC
    variable = u
    function = 'if(x<0.565, 0.05, 0.5)'
  []
[]

[AuxVariables]
  [phi1]
    order = FIRST
    family = LAGRANGE
  []
  [cut1_id]
    order = CONSTANT
    family = MONOMIAL
  []
  [phi2]
    order = FIRST
    family = LAGRANGE
  []
  [cut2_id]
    order = CONSTANT
    family = MONOMIAL
  []
  [combo_id]
    order = CONSTANT
    family = MONOMIAL
  []
[]


[Kernels]
  [diff]
    type = MatDiffusion
    variable = u
    diffusivity = diffusion_coefficient
  []
  [time]
    type = TimeDerivative
    variable = u
  []
[]

[AuxKernels]
  [phi1]
    type = MeshCutLevelSetAux
    mesh_cut_user_object = cut_mesh_phi1
    variable = phi1
    execute_on = 'TIMESTEP_BEGIN'
  []
  [cut1_id]
    type = CutSubdomainIDAux
    variable = cut1_id
    cut = cut1
  []
  [phi2]
    type = MeshCutLevelSetAux
    mesh_cut_user_object = cut_mesh_phi2
    variable = phi2
    execute_on = 'TIMESTEP_BEGIN'
  []
  [cut2_id]
    type = CutSubdomainIDAux
    variable = cut2_id
    cut = cut2
  []
  [combo_id]
    type = CutSubdomainIDAux
    variable = combo_id
    cut = combo
  []
[]

[Materials]
  [ZrO2]
    type = GenericConstantMaterial
    prop_names = A_diffusion_coefficient
    prop_values = 1.18e-4
  []
  [Zr_alpha]
    type = GenericConstantMaterial
    prop_names = B_diffusion_coefficient
    prop_values = 8.5e-6
  []
  [Zr_beta]
    type = GenericConstantMaterial
    prop_names = C_diffusion_coefficient
    prop_values = 1.83e-4
  []
  [diff_combined]
    type = XFEMCutSwitchingMaterialReal
    cut_subdomain_ids = '1 3 5 7'
    base_names = 'A B B C'
    prop_name = diffusion_coefficient
    geometric_cut_userobject = combo
    outputs = 'exodus'
    output_properties = 'diffusion_coefficient'
  []
[]

[BCs]
  # Define boundary conditions
  [right_u]
    type = DirichletBC
    variable = u
    value = 0.67
    boundary = right
  []

  [left_u]
    type = NeumannBC
    variable = u
    boundary = left
    value = 0
  []
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  line_search = 'none'

  l_tol = 1e-3
  nl_max_its = 15
  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-5

  start_time = 0.0
  dt = 0.01
  num_steps = 100
  max_xfem_update = 1
[]

[Outputs]
  execute_on = timestep_end
  exodus = true
  perf_graph = true
[]