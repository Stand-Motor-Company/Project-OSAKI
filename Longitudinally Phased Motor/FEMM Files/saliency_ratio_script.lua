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

-- Rotate the rotor for unaligned analysis
mi_selectgroup(9)
mi_moverotate(0, 0, 30)  -- Adjust this angle based on your motor design

-- Analyze the unaligned position
mi_analyze()
mi_loadsolution()

local L_unaligned = computeInductance("Coil")
if L_unaligned then
    print('Unaligned Inductance: ', L_unaligned)
else
    print('Failed to compute unaligned inductance.')
end

-- Rotate the rotor for aligned analysis
mi_selectgroup(9)
mi_moverotate(0, 0, -30)  -- Adjust this angle based on your motor design
mi_analyze()
mi_loadsolution()

local L_aligned = computeInductance("Coil")
if L_aligned then
    print('Aligned Inductance: ', L_aligned)
else
    print('Failed to compute aligned inductance.')
end

-- Calculate and print the Saliency Ratio
if L_aligned and L_unaligned then
    local Saliency_Ratio = L_aligned / L_unaligned
    print('Saliency Ratio: ', Saliency_Ratio)
else
    print('Error calculating Saliency Ratio due to previous errors.')
end

