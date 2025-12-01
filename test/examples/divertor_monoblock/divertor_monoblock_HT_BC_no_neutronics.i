# This is the BC used when no neutronics is being coupled
# This complements divertor_monoblock_base.i

[BCs]
    [temperature_top]
        type = FunctionNeumannBC
        variable = temperature
        boundary = 'top'
        function = temperature_flux_bc_func
    []
[]

[Functions]
    ### Heat flux of 10MW/m^2 at steady state
    [temperature_flux_bc_func]
        type = ParsedFunction
        expression =   'if((t % 1600) < 100.0, 0.0   + 1.0e7*(t % 1600)/100,
                        if((t % 1600) < 500.0, 1.0e7,
                        if((t % 1600) < 600.0, 1.0e7 - 1.0e7*((t % 1600)-500)/100, 300)))'
    []
[]
