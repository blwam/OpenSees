# BoucWenHDRB Source Code Repository

A modified version of the Bouc-Wen model for simulating High Damping Rubber Bearings (HDRB) in OpenSees. This repository contains the source code for a custom HDRB element, designed to capture nonlinear behavior under extreme loading conditions.

## Authors

- Yuhang Lu  
  Sichuan University, Chengdu, China  
  Email: ll05734823@gmail.com  
- Peng Chen  
  Sichuan University, Chengdu, China  
- Bin Wang  
  Sichuan University, Chengdu, China

## Usage Instructions

This command is used to construct a BoucWenHDRB element object for modeling high damping rubber bearings (HDRBs), which is defined by two nodes with a total of 12 degrees of freedom. The bearing features a nonlinear shear model consisting of a linear spring, a basic hysteretic spring, and an added hysteretic spring, while the force-deformation behavior in the remaining directions is defined by corresponding UniaxialMaterials. It extends the formulation of [elastomericBearingBoucWen](https://opensees.berkeley.edu/wiki/index.php?title=Elastomeric_Bearing_(Bouc-Wen)_Element) by including large strain stiffening, degradation, temporary hardening, and initial hardening.

For a three-dimensional problem:

```
element BoucWenHDRB $eleTag $Nd1 $Nd2 $kInit $fy $alphaL $Tr -P $matTag -T $matTag -My $matTag -Mz $matTag <-alpha1 $alpha1> <-beta1 $beta1> <-gamma1 $gamma1> <-eta $eta> <-alpha2 $alpha2> <-beta2 $beta2> <-gamma2 $gamma2> <-c1 $c1> <-c2 $c2> <-orient $x1 $x2 $x3 $y1 $y2 $y3> <-sDratio $sDratio> <-mass $mass>
```

---

| Parameter | Description |
|--------|------|
| `$eleTag` | unique element object tag |
| `$Nd1 $Nd2` | end nodes |
| `$kInit` | initial stiffness of HDRB |
| `$fy` | yield strength |
| `$alphaL` | post-yield stiffness ratio in the first cycle |
| `$Tr` | total rubber thickness |
| `-P $matTag` | tag associated with previously-defined UniaxialMaterial in axial direction |
| `-T $matTag` | tag associated with previously-defined UniaxialMaterial in torsional direction |
| `-My $matTag` | tag associated with previously-defined UniaxialMaterial in moment direction around local y-axis |
| `-Mz $matTag` | tag associated with previously-defined UniaxialMaterial in moment direction around local z-axis |
| `$alpha1` | shape control parameter for hysteresis variable z1 (optional, default = 1.0) |
| `$beta1` | shape control parameter for hysteresis variable z1 (optional, default = 0.5) |
| `$gamma1` | shape control parameter for hysteresis variable z1 (optional, default = 0.5) |
| `$eta` | shape control parameter for hysteresis variable z1 (optional, default = 1.0) |
| `$alpha2` | shape control parameter for hysteresis variable z2 (optional, default = 0.01) |
| `$beta2` | shape control parameter for hysteresis variable z2 (optional, default = 0.03) |
| `$gamma2` | shape control parameter for hysteresis variable z2 (optional, default = -0.05) |
| `$c1` | shape control parameter (optional, default = 2.4e-2) |
| `$c2` | shape control parameter (optional, default = 9e2 N) |
| `$x1 $x2 $x3 $y1 $y2 $y3` | vector components in global coordinates defining local x-axis and y-axis (optional) |
| `$sDratio` | shear distance from Nd1 as a fraction of the element length (optional, default = 0.5) |
| `$mass` | element mass (optional, default = 0.0) |

![](https://raw.githubusercontent.com/blwam/OpenSees/refs/heads/BoucWenHDRB/BoucWenHDRB_src/fig1.png)
![](https://raw.githubusercontent.com/blwam/OpenSees/refs/heads/BoucWenHDRB/BoucWenHDRB_src/fig2.png)

---

**Example:**

```
element BoucWenHDRB 1 1 2 9.1e6 20e3 0.091 0.09 -P 9 -T 6 -My 6 -Mz 6
```

**Recorders:**

The valid queries to an BoucWenHDRB element when creating an ElementRecorder object are 'force,' 'localForce,' 'basicForce,' 'localDisplacement,' 'basicDisplacement' and 'params'.
