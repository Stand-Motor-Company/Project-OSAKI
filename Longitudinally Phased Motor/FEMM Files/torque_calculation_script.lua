-- Function to fetch and compute inductance
function computeInductance(circuitName)
    local current, unknown, flux = mo_getcircuitproperties(circuitName)
    if current and flux then
        if current ~= 0 then
            return flux / current
        else
            print("Error: Current is zero, cannot compute inductance.")
            return nil
        end
    else
        print("Error: Coil properties not found or invalid. Check circuit name and analysis results.")
        return nil
    end
end


local torque = 0
local angleStep = -1

mi_analyze()
mi_loadsolution()
    
-- Compute the torque using the gap integral method
mi_selectgroup(9)
local saliency = computeInductance("Coil")
mi_clearselected()
mo_selectblock(0,10)
mo_zoomnatural()
torque = mo_blockintegral(22)
print('0,degrees,' .. torque .. ',Nm,' .. saliency .. ',Inductance')

-- Rotate the rotor and calculate torque at each step
for angle = angleStep, -60, angleStep do  -- adjust the step size as needed
    mi_clearselected()
    mi_selectgroup(9)
    mi_moverotate(0, 0, angleStep)
    mi_analyze()
    mi_loadsolution()
    
    -- Compute the data
    saliency = computeInductance("Coil")
    mi_clearselected()
    mo_selectblock(0,10)
    mo_zoomnatural()
    torque = mo_blockintegral(22)
    print(angle .. ',degrees,' .. torque .. ',Nm,' .. saliency .. ',Inductance')
end