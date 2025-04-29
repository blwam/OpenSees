# Clear existing model
wipe

# -----------------------------------------------------------
# User-defined parameters
# -----------------------------------------------------------
set g 9.810;  # Gravitational acceleration
set pi 3.14159;  # Value of pi

set kInit 22562428
set qYield0 209750
set alphaL 0.05;  # Post-yield stiffness ratio
set dL 139.7e-03;  # Inner diameter of bearing
set D2 508e-03;  # Outer diameter of bearing
set ts 4.76e-03;  # Single steel shim thickness
set tr 9.525e-03;  # Single rubber layer thickness
set n 16;  # Number of rubber layers

set alpha1 1
set beta1 0.5
set gamma1 0.5
set alpha2 0.01
set beta2 0.08
set gamma2 -0.173

set c1 1.8e-2
set eta 1

set E2 0.0069
set rhoL 11200
set cL 130
set kS 50
set alphaS 1.41e-5
set TL0 20

set c2 0.3
set c3 1.2
set cd 128000

set sDratio 0.5
set mass 0.0

set Tr [expr $n * $tr];  # Total rubber thickness
set Ts [expr ($n-1) * $ts];  # Total steel shim thickness
set h [expr $Tr + $Ts];  # Total bearing height

set M 146890;  # Mass of superstructure

# Start model generation
model basic -ndm 3 -ndf 6

# Create nodes
node 1 0 0 0
node 2 0 $h 0

# Define single-point constraints
fix 1 1 1 1 1 1 1
fix 2 0 0 0 1 1 1

# Define elastic materials
uniaxialMaterial Elastic 6 0;  # Constraints for overturning and torsion
uniaxialMaterial Elastic 7 3384364;
uniaxialMaterial ENT 8 513220226;
uniaxialMaterial Parallel 9 7 8;  # Parallel material

# Define BoucWenLRB element
element BoucWenLRB 1 1 2 $kInit $qYield0 $alphaL $dL $ts $tr $n \
    -P 9 -T 6 -My 6 -Mz 6 \
    -alpha1 $alpha1 -beta1 $beta1 \
    -gamma1 $gamma1 -eta $eta \
    -alpha2 $alpha2 -beta2 $beta2 -gamma2 $gamma2 \
    -c1 $c1 \
    -flagLH \
    -E2 $E2 -rhoL $rhoL \
    -cL $cL -kS $kS \
    -alphaS $alphaS -TL0 $TL0 \
    -flagIH \
    -c2 $c2 -c3 $c3 \
    -cd $cd \
    -orient 0 1 0 1 0 0 \
    -sDratio $sDratio -mass $mass

# print ele 1

# Define loads
set P [expr $M * $g]
timeSeries Linear 10
pattern Plain 1 10 {
    load 2 0.0 -[expr $P] 0.0 0.0 0.0 0.0
}

# Set up analysis
system BandSPD
constraints Transformation
numberer RCM
test NormDispIncr 1.0e-15 10 3
algorithm Newton
integrator LoadControl 1
analysis Static

# Perform analysis
set ok [analyze 1]

# Print analysis results
if {$ok == 0} {
    puts "Gravity analysis completed SUCCESSFULLY"
} else {
    puts "Gravity analysis FAILED"
}

