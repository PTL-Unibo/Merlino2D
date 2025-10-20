# Merlino 2D

## Structure
The main folder contains 6 sub-folders:
- code/
- geo/
- data/
- cases/
- kinetic/
- doc/

**code/** contains all the functions that compose **Merlino2D**, organized in sub-folders. It also contains the script **Merlino2D_startup.m**, that needs to be run only the first time the code is used.

**geo/** contains the **.geo** mesh files that are generated with the Gmsh program. Some files are already present inside this folder and are used to run the example cases. New mesh files created by the user must be placed inside this directory.

**data/** contains several **.csv** files that specify the dependence of physical quantities (Townsend first ionization coefficient, electron temperature, etc..) on the reduced electric field. This information can be used for the definition of species mobilities or diffusion coefficients, and also for the definition of rate coefficients.
The folder also contains the experimental results obtained by [Kiousis et al.](https://iopscience.iop.org/article/10.1088/1009-0630/16/4/11) for an I-V characteristic of a corona discharge in a wire-cylinder configuration, used for comparison with the results obtained from the code.

**cases/** contains the scripts for running some tests, with the aim of illustrating the capabilities of the code. In the examples provided, accuracy has been sacrificed to reduce the computational time.

**kinetic/** contains the definition of the kinetic schemes. Some kinetic schemes for air have already been provided and are used to run the examples. New kinetic schemes defined by the user must be placed inside this folder.

**doc/** contains the user manual of the code. 

In addition, the main folder contains also the script **init.m**, that always needs to be run before using the code, and the LoKI-B input file **Air.in**, that you should place inside the **Input/** folder of the LoKI-B directory contained inside **Merlino0D** distribution (in case you want to use the Boltzmann solver capabilities). 

## Installation
To use Merlino2D you need MATLAB installed on your computer.
You also need to install Gmsh for mesh generation.
If you wish to use the functionalities of the LoKI-B Boltzmann solver, you should also have available on your computer [Merlino0D](https://github.com/apopoli/Merlino).

The first time using Merlino2D it is necessary to run the script **Merlino2D_startup.m**
that is inside the **code/** folder.
By running this script, you will be asked to select the **gmsh.exe** executable (that you should have previously installed), and the LoKI-B folder (that is contained inside Merlino0D main directory).

If the folder containing the project is moved to another location, you need to run **Merlino2D_startup.m** again.

## Workflow
Every time you open MATLAB, to use the code you have to run the script **init.m** 
that is inside the main folder. You can do it by selecting the file and pressing **F9**, or typing in the Command Window
```
init
```
This will add to the MATLAB path the folder **code/** that contains the code.


The core of the code is the function `Merlino2D`, the syntax is

```
out = Merlino2D(opts,"key1",value1,"key2",value2,...);
```
`opts` is a structure that contains the input parameters for the simulation. 
Default values for these parameters can be found inside **DefaultMerlino2Dinput.m**.

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