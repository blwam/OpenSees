# BoucWenLRB Source Code Repository

A modified version of the Bouc-Wen model for simulating Lead Rubber Bearings (LRBs) in OpenSees. This repository contains the source code for a custom LRB element, designed to capture nonlinear behavior under extreme loading conditions.

## Authors

- Yuhang Lu  
  Sichuan University, Chengdu, China  
  Email: ll05734823@gmail.com  
- Peng Chen  
  Sichuan University, Chengdu, China  
- Bin Wang  
  Sichuan University, Chengdu, China

## Usage Instructions

This command is used to construct a BoucWenLRB element object for modeling Lead Rubber Bearings (LRBs), which is defined by two nodes with a total of 12 degrees of freedom. The bearing features a nonlinear shear model consisting of a linear spring, a basic hysteretic spring, an added hysteretic spring, and a viscous element, while the force-deformation behavior in the remaining directions is defined by corresponding UniaxialMaterials. It extends the formulation of [elastomericBearingBoucWen](https://opensees.berkeley.edu/wiki/index.php?title=Elastomeric_Bearing_(Bouc-Wen)_Element) by including initial hardening, large strain stiffening, degradation, and strength reduction caused by lead core heating.

For a three-dimensional problem:

```
element BoucWenLRB $eleTag $Nd1 $Nd2 $kInit $fy $alphaL $dL $ts $tr $n -P $matTag -T $matTag -My $matTag -Mz $matTag <-alpha1 $alpha1> <-beta1 $beta1> <-gamma1 $gamma1> <-eta $eta> <-alpha2 $alpha2> <-beta2 $beta2> <-gamma2 $gamma2> <-c1 $c1> <-flagLH> <-E2 $E2> <-rhoL $rhoL> <-cL $cL> <-kS $kS> <-alphaS $alphaS> <-TL0 $TL0> <-flagIH> <-c2 $c2> <-c3 $c3> <-cd $cd> <-orient $x1 $x2 $x3 $y1 $y2 $y3> <-sDratio $sDratio> <-mass $mass>
```

---

| Parameter | Description |
|--------|------|
| `$eleTag` | unique element object tag |
| `$Nd1 $Nd2` | end nodes |
| `$kInit` | initial stiffness of LRB |
| `$fy` | yield strength |
| `$alphaL` | post-yield stiffness ratio in the first cycle |
| `$dL` | diameter of the lead core |
| `$ts` | single steel shim layer thickness |
| `$tr` | single rubber layer thickness |
| `$n` | number of rubber layers |
| `-P $matTag` | tag associated with previously-defined UniaxialMaterial in axial direction |
| `-T $matTag` | tag associated with previously-defined UniaxialMaterial in torsional direction |
| `-My $matTag` | tag associated with previously-defined UniaxialMaterial in moment direction around local y-axis |
| `-Mz $matTag` | tag associated with previously-defined UniaxialMaterial in moment direction around local z-axis |
| `$alpha1` | shape control parameter for hysteresis variable z1 (optional, default = 1.0) |
| `$beta1` | shape control parameter for hysteresis variable z1 (optional, default = 0.5) |
| `$gamma1` | shape control parameter for hysteresis variable z1 (optional, default = 0.5) |
| `$eta` | shape control parameter for hysteresis variable z1 (optional, default = 1.0) |
| `$alpha2` | shape control parameter for hysteresis variable z2 (optional, default = 0.01) |
| `$beta2` | shape control parameter for hysteresis variable z2 (optional, default = 0.08) |
| `$gamma2` | shape control parameter for hysteresis variable z2 (optional, default = -0.173) |
| `$c1` | shape control parameter for degradation (optional, default = 0.018) |
| `$flagLH` | Optional flag to enable lead core heating; if omitted, the effect is disabled |
| `$E2` | shape parameter of lead core heating (optional, default = 0.0069) |
| `$rhoL` | density of lead (optional, default = 11200 kg/m<sup>3</sup>) |
| `$cL` | specific heat of lead (optional, default = 130 J/(kg·℃)) |
| `$kS` | thermal conductivity of steel (optional, default = 50 W/(m·℃)) |
| `$alphaS` | thermal diffusivity of steel (optional, default = 1.41e-5 m<sup>2</sup>/s) |
| `$TL0` | initial temperature of lead core (optional, default = 20 ℃) |
| `$flagIH` | Optional flag to enable initial hardening; if omitted, the effect is disabled |
| `$c2` | shape control parameter for initial hardening (optional, default = 0.6) |
| `$c3` | shape control parameter for initial hardening (optional, default = 1.2) |
| `$cd` | viscous damping parameter (optional, default = 0.0) |
| `$x1 $x2 $x3 $y1 $y2 $y3` | vector components in global coordinates defining local x-axis and y-axis (optional) |
| `$sDratio` | shear distance from Nd1 as a fraction of the element length (optional, default = 0.5) |
| `$mass` | element mass (optional, default = 0.0) |

![](https://raw.githubusercontent.com/blwam/OpenSees/refs/heads/BoucWenLRB/BoucWenLRB_SRC/BoucWenLRB.svg)

## Recorders

The valid queries to an BoucWenLRB element when creating an ElementRecorder object are 'force,' 'localForce,' 'basicForce,' 'localDisplacement,' 'basicDisplacement' and 'params'.

The 'params' query returns the following variables in order: DMplus, DMminus, DM, dTL, DI, KL, KT1, and KI, where DM is the damage measure of the degradation behavior, DMplus and DMminus are two damage thresholds to govern the evolution of DM, dTL is the change in temperature of lead core from the reference temperature TL0, DI is the cumulative shear deformation, KL is the correction coefficient for large deformation, KT1 is the correction coefficient for lead core heating, KI is the correction coefficient for initial hardening.

## Example

Example_1

This example is used to demonstrate the strength reduction effect caused by lead core heating, based on experimental data from Kalpakidis et al. (2010). The simulation results obtained from the BoucWenLRB element are compared with the experimental results.

The TCL scripts and input files for this example are located in `BoucWenLRB_SRC/Example_1`.

![](https://raw.githubusercontent.com/blwam/OpenSees/refs/heads/BoucWenLRB/BoucWenLRB_SRC/Example_1/Example_1.svg)

Example_2

This example is used to demonstrate the large strain nonlinear behavior of the bearing. A quasi-static cyclic shear test is conducted on a lead rubber bearing specimen (LRB600). The shear strain amplitude is progressively increased in stages, reaching a maximum shear strain of 350%. The simulation results obtained from the BoucWenLRB element are compared with the experimental results.

The TCL scripts and input files for this example are located in `BoucWenLRB_SRC/Example_2`.

![](https://raw.githubusercontent.com/blwam/OpenSees/refs/heads/BoucWenLRB/BoucWenLRB_SRC/Example_2/Example_2.svg)

## References

1. Kalpakidis, I. V., Constantinou, M. C., & Whittaker, A. S. (2010). Modeling strength degradation in lead–rubber bearings under earthquake shaking. Earthquake Engineering & Structural Dynamics, 39(13), 1533–1549. https://doi.org/10.1002/eqe.1039
