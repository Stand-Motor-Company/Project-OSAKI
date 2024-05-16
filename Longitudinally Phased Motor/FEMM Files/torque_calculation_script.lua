local torque = 0
local angleStep = -1

mi_analyze()
mi_loadsolution()
    
-- Compute the torque using the gap integral method
mi_clearselected()
mo_selectblock(0,120)
mo_selectblock(-104,-62)
mo_selectblock(104,-62)
mo_zoomnatural()
torque = mo_blockintegral(22)
print('0,degrees,' .. torque .. ',Nm')

-- Rotate the rotor and calculate torque at each step
for angle = angleStep, -60, angleStep do  -- adjust the step size as needed
    mi_clearselected()
    mi_selectgroup(9)
    mi_moverotate(0, 0, angleStep)
    mi_analyze()
    mi_loadsolution()
    
    -- Compute the torque using the gap integral method
    mi_clearselected()
    mo_selectblock(0,10)
    mo_selectblock(-104,-62)
    mo_selectblock(104,-62)
    mo_zoomnatural()
    torque = mo_blockintegral(22)
    print(angle .. ',degrees,' .. torque .. ',Nm')
end