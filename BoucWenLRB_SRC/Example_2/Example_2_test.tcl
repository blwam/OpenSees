# source the gravity analysis file
source Example_2_gravity.tcl

# Maintain gravity loads and reset time
loadConst -time 0.0

# Assign mass to node 2
mass 2 $M $M $M 0 0 0

# Set file paths
set disp_file "Example_2_disp_dt0.05.txt"
set vel_file "Example_2_vel_dt0.05.txt"
set acc_file "Example_2_acc_dt0.05.txt"

# Define time step and data length
set dt_th 0.05
set data_len 80913

# Define time series
timeSeries Path 1 -dt $dt_th -filePath $disp_file -factor 1
timeSeries Path 2 -dt $dt_th -filePath $vel_file -factor 1
timeSeries Path 3 -dt $dt_th -filePath $acc_file -factor 1

# Apply multiple support excitation
pattern MultipleSupport 2 {
    groundMotion 1 Plain -disp 1 -vel 2
    imposedMotion 2 1 1
}

# Define output recorders
recorder Node -file "output\\nodeDisp.out" -time -node 2 -dof 1 2 3 disp
recorder Element -file "output\\basicForce.out" -time -ele 1 basicForce
recorder Element -file "output\\basicDisplacement.out" -time -ele 1 basicDisplacement
recorder Element -file "output\\params.out" -time -ele 1 params
recorder Element -file "output\\dzdu.out" -time -ele 1 dzdu

# Set up analysis
wipeAnalysis
system BandGeneral
constraints Transformation
test EnergyIncr 1.0e-9 200
algorithm KrylovNewton
numberer Plain
integrator Newmark 0.5 0.25
analysis Transient


# Perform transient analysis
set dt_fem $dt_th
set tFinal [expr $data_len * $dt_th]
set tCurrent [getTime]
set analysisStatus 0

while { $analysisStatus == 0 && $tCurrent < $tFinal } {
    set analysisStatus [analyze 1 $dt_fem]

    if { $analysisStatus != 0 } {
        puts "regular newton failed .. trying initial stiffness for this step"
        test NormDispIncr 1.0e-12 100 0
        algorithm ModifiedNewton -initial
        set analysisStatus [analyze 1 $dt_fem]
        if { $analysisStatus == 0 } {
            puts "that worked .. back to regular newton"
        }
        test NormDispIncr 1.0e-12 10
        algorithm Newton
    }

    set tCurrent [getTime]
}

# Print analysis results
if { $analysisStatus == 0 } {
    puts "Transient analysis completed SUCCESSFULLY"
} else {
    puts "Transient analysis FAILED"
}
