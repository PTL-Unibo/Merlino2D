# Merlino2D
Merlino2D is an open-source plasma simulation code designed to provide a fast and user-friendly platform for modeling a broad range of plasma devices and gas discharges. The code is based on a drift–diffusion fluid framework and can accommodate detailed kinetic reaction schemes, depending on the chosen mesh resolution. Merlino2D employs a fully implicit time-integration scheme with adaptive time stepping, enabling stable and computationally efficient simulations. The code is implemented in MATLAB and supports two-dimensional plasma simulations on unstructured triangular meshes generated using Gmsh.

## Structure
The main folder contains the script **init.m**, that always needs to be run before using the code.

The main folder also contains 6 sub-folders:

### cases/ 
Contains the scripts for running some tests, with the aim of illustrating the capabilities of the code:
- **c_CoronaWireCylinder.m**
- **c_CoronaWireWireGrid.m**
- **c_DBD.m**
- **c_Diffusion.m**
- **c_Drift.m**

In the examples provided, accuracy has been sacrificed to reduce the computational time.

---
### data/ 
Contains the csv variables (described in chapter 6.11 of the user manual) created by the user. Some files of this type are already present inside this folder:
- **alpha_Air.csv**
- **eta_Air.csv**
- **D_Air.csv**
- **mu_Air.csv**
- **Te_Air.csv**
- **k1_Koz.csv**
- **k2_Koz.csv**

New csv variables must be placed inside the **data/** folder.

The folder also contains the file **species_database.csv**, where information about the mass and charge of species should be stored.

In addition, the folder contains experimental results obtained by [Kiousis et al.](https://iopscience.iop.org/article/10.1088/1009-0630/16/4/11) for an I-V characteristic of a corona discharge in a wire-cylinder configuration (**Experimental_Results_50u_5m_30m.csv**), used for comparison with the results obtained from the code when running the test **c_CoronaWireCylinder.m**.

---
### doc/
Contains the user manual of the code. 

---
### geo/
Contains the **.geo** mesh files that are generated with the Gmsh program. Some files are already present inside this folder and are used to run the example cases:
- **DBD.geo**
- **Square.geo**
- **SquareCenterRefined.geo**
- **WireCyl_50u_5m_30m.geo**
- **WireWireGrid.geo**

New mesh files created by the user must be placed inside this directory.

---
### kinetic/
Contains the definition of the kinetic schemes. Some kinetic schemes for air have already been provided and can be used as reference for the creation of custom ones.
The provided kinetic schemes are:
- **s_Kozhevnikov.m**
- **s_Parent.m**
- **s_ParentLoki.m**
- **s_Townsend.m**
- **s_TownsendLoki.m**

New kinetic schemes defined by the user must be placed inside this folder. Note that the kinetic scheme can refer to any gas mixture.

---
### src/ 
Contains all the functions that compose **Merlino2D**, organized in sub-folders. It also contains the script **Merlino2D_startup.m**, that needs to be run only the first time the code is used.

## Installation
To use Merlino2D you need MATLAB installed on your computer.
You also need to install [Gmsh](https://gmsh.info/) for mesh generation.

The first time using Merlino2D it is necessary to run the script **Merlino2D_startup.m**
that is inside the **src/** folder.
By running this script, you will be firstly asked to select the **gmsh.exe** executable, that you should have previously installed on your computer.
After, you will be asked to select the **Code/** folder of the [LoKI-B](https://github.com/LoKI-Suite/LoKI-B) repository, that you should have cloned on your device if you wish to have the option of using the Boltzmann solver for computing swarm parameters and rate coefficients.

If the folder containing the project is moved to another location, you need to run **Merlino2D_startup.m** again.



## Workflow
Every time you open MATLAB, to use the code you have to run the script **init.m** 
that is inside the main folder. You can do it by selecting the file and pressing **F9**, or typing in the Command Window
```
init
```
This will add to the MATLAB path the folder **src/** that contains the code.


The core of the code is the function `Merlino2D`, the syntax is

```
out = Merlino2D(opts,"key1",value1,"key2",value2,...);
```
`opts` is a structure that contains the input parameters for the simulation. 
Some parameters have default values that can be found inside **DefaultMerlino2Dinput.m**.

The key-value arguments are optional and can be used to overwrite the parameters passed though `opts`.

`out` is the unprocessed output structure that is given in input to the `PostProcessing` function to obtain the post-processed output structure `out_pp`. 
```
out_pp = PostProcessing(out);
```
`out_pp` can be used to plot the results using the `Plot` function. 
```
Plot(out_pp,"type",type_value);
```
To save the results of a simulation, use the `Save` function.
```
Save(out_pp,"my_result.mat");
```
To retrieve the results of a simulation that was previously saved, use the `Load` function.
```
out_pp = Load("my_result.mat");
```
It is also possible to export the results for visualization with Paraview using the `ExportVTU` function. 
```
ExportVTU(out_pp,"my_results")
```



## Test
To perform a comprehensive test, you can run the script **c_CoronaWireWireGrid.m** that is inside the folder **cases/**.
This simulation will use LoKI-B to compute the mobility and diffusion coefficient of electrons, and also the electron temperature as a function of the reduced electric field.

It will also use the [three-exponential Helmholtz model of photoionization](https://iopscience.iop.org/article/10.1088/0963-0252/16/3/026) during the simulation.
