# A Short Species Distribution Modeling Tutorial


This repository is a fork from (@dondealban) and contains a short tutorial for creating a species distribution model using QGIS, R, and MaxEnt. The original tutorial was prepared for the skills training sessions during the lab retreat of the [Applied Plant Ecology Lab](https://www.appliedplantecology.org), Department of Biological Sciences, National University of Singapore held on 25-28 September 2017 in Malacca, Malaysia. This version is an adapted version for the QGIS, R and Maxent part of the data use workshop organized by the [Belgian Biodiversity Platform](http://biodiversity.be). 


## Table of Contents
- [Download and Installation](#download)
- [Study Area](#study_area)
- [Prepare Datasets](#prepare_datasets)
- [Model Species Distributions](#model_species_distribution)
- [Further Reading](#further_reading)
- [References](#references)
- [License](#license)
- [Want to Contribute?](#contribute)


<a name="download"></a>
## Download and Installation

#### Software
For this tutorial, download and install [QGIS](http://www.qgis.org/en/site/forusers/download.html), [Rstudio](https://www.rstudio.com/), [OpenRefine](http://openrefine.org) and [MaxEnt](https://biodiversityinformatics.amnh.org/open_source/maxent/), all of which are free and open-source software. For QGIS and R, download the versions compatible with your machine's operating system. MaxEnt is a Java-based application and runs using various operating systems. The procedures shown in this tutorial uses a Windows platform but it should be applicable to other operating systems.

#### Data
MaxEnt will require two types of input datasets:

1. **Species occurrence data.** The species occurrence records are the geographic point locations or coordinates of species observations. For this exercise, we will use data downloaded from [GBIF](www.gbif.org). For this tutorial we used this dataset [data](https://doi.org/10.15468/dl.cu4aii) (249 KB, CSV file) [Papilio machaon](https://en.wikipedia.org/wiki/Papilio_machaon) occurrences in Flanders, Belgium. The dataset only holds occurrences between 1960 and 1990, because of the WorldClim data available. You can also find the file [here](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/csv/Papilio_machaon.csv). 
	
	- Create a folder for csv's and place the occurrence data there. Name your file Papilio_machaon 
	- Clean your dataset
		- remove all occurrences which do not pertain to Flanders
		- remove all suspicious occurrences (occurrences in the ocean...)
		- Check your desired occurrence precission.

2. **Environmental predictors.** The environmental covariates consist of raster data that contain either continuous or categorical values such as precipitation, temperature, elevation, etc. We will be using the [WorldClim](http://www.worldclim.org) raster datasets. WorldClim is a set of gridded global climate data layers, which can be used for mapping and ecological modeling. For this exercise, we will use [WorldClim v.1.4 Current conditions](http://www.worldclim.org/current) (or interpolations of observed data from 1960-1990). We will need the highest resolution data available provided at 30 arc-seconds (~1 km);  You can read [Hijmans et al. (2005)](#hijmans_etal_2005) for more information about the climate data layers. The WorldClim 0.5 (Bio16_zip) dataset for Europe can be downloaded [here](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/rasters/wc0.5_europe/bio_16.zip) for present data and [here](file:///C:\Users\dimitri_brosens\Documents\GitHub\tutorial-qgis-maxent\rasters\world) for future scenario's.  *note*

	-Next, we will unzip the bio_16.zip file in the appropriate folders.

One variable, used frequently in niche modelling is the altitude. The altitude is not included in the WorldClim dataset. We can use the GTOPO30 dataset. It will provide us the altitude information on a similar resolution. The GTOP30 data can be downloaded [here](https://lta.cr.usgs.gov/GTOPO30). 

To prepare the datasets, we will also need **administrative boundary** data. We can use the administrative boundary vector data from the [Global Administrative Database](http://www.gadm.org/country). On GADM's Download page, select "Belgium" and "Shapefile" from the *Country* and *Format* drop-down menus, respectively, and click the [download](http://biogeo.ucdavis.edu/data/gadm2.8/shp/PHL_adm_shp.zip) link provided (~22 MB, ZIP file). For this exercise we will use this file [FlandersWGS84](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/shp/Belgium/Vlaanderen_WGS84-20180703T080424Z-001.zip)

- Alternatively you can draw a polygon which you can use for creating the training area for niche modeling. Your training area shape should contain all the occurrences you need to use for your niche modelling. You need to save this polygon as a .shp file so you can clip the environmental raster data correct.

##Draw your training polygon in Qgis

- Open your (Cleaned) occurrences layes in Qgis
- In Layers, choose Create "New shapefile"" layer
- In the resulting window click the button for "polygon", click ok and name your polygon      `'Species_name'_TrainingRegionFlanders`
  
  ![CreatePolygon](https://github.com/dimevil/tutorial-qgis-maxent/blob/master/screenshots/Qgis_data-prep-create-polygon.PNG=250x)
  
- Select your new layer (is highlighted) in the panels section
- Hit the Edit button
- Choose "Create new polygon" button
- Draw your Training Area
  Every time you left click on the map, a dot will be created. QGIS will draw lines to connect these dots to create a polygon. If you mis-click, do not worry - you will be able to move points to the appropriate place.
- Right click anywhere on the map, leave inout an ID blank and hit OK
- Click on the "node" tool to edit your training layer
- Save layer as shapefile

  ![CreatePolygon](https://github.com/dimevil/tutorial-qgis-maxent/blob/master/screenshots/Qgis_data-prep-create-polygon2.PNG)


You can find a usable training region for Flanders (here)[https://github.com/DimEvil/tutorial-qgis-maxent/tree/master/shp/trainingRegionFlanders]


<a name="study_area"></a>
## Study Area
**Belgium** Belgium (/ˈbɛldʒəm/ (About this sound listen) BEL-jəm),[A] officially the Kingdom of Belgium, is a country in Western Europe bordered by France, the Netherlands, Germany and Luxembourg. A small and densely populated country, it covers an area of 30,528 square kilometres (11,787 sq mi) and has a population of more than 11 million. Straddling the cultural boundary between Germanic and Latin Europe, Belgium is home to two main linguistic groups: the Dutch-speaking, mostly Flemish community, which constitutes about 59 percent of the population, and the French-speaking, mostly Walloon population, which comprises about 40 percent of all Belgians. Additionally, there is a small ~1 percent group of German speakers who live in the East Cantons.

**Flanders** Flanders (Dutch: Vlaanderen [ˈvlaːndərə(n)] (About this sound listen), French: Flandre [flɑ̃dʁ], German: Flandern [ˈflandɐn]) is the Dutch-speaking northern portion of Belgium, although there are several overlapping definitions, including ones related to culture, language, politics and history. It is one of the communities, regions and language areas of Belgium. The demonym associated with Flanders is Fleming, while the corresponding adjective is Flemish. The official capital of Flanders is Brussels,[1] although the Brussels Capital Region has an independent regional government, and the government of Flanders only oversees the community aspects of Flanders life there such as (Flemish) culture and education.

![study-area](https://github.com/dimEvil/tutorial-qgis-maxent/blob/master/poster/N2000Belgium.jpg)

<a name="prepare_datasets"></a>
## Prepare Datasets

1. First, we will create subsets from the environmental rasters to focus our modeling over our study area. To do this, we will create a polygon shapefile containing the extent of the study area and use this shapefile to clip all the raster map layers. Follow these steps using QGIS:

    - Load the **vlaanderen_wgs84.shp** [shapefile](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/shp/Flanders/Vlaanderen_WGS84.shp) by adding a vector layer from the **`Layer > Add Layer > Add Vector Layer...`** menu. This displays the municipal-level administrative boundaries. Make sure the shapefile you will use has the correct SRS. In most cases WGS84.

    ![data-prep1](https://github.com/dimevil/tutorial-qgis-maxent/blob/master/screenshots/qgis_data-prep-01a.png)

    - Next, we will create a polygon from the extent of the Flanders shapefile that we have just saved. Go to **`Vector > Research Tools > Polygon from Layer Extent`** menu.

      + Under the `Input Layer` drop-down menu, select the newly created **vlaanderen_wgs84.shp** shapefile.
      + Under the `Extent` input line, select **`Save to File`** from the menu to save the file in your working directory. Then, click `Run` to create another shapefile called **box1.shp**, which consists of a polygon covering the extent of the study area.

    ![data-prep4](https://github.com/dimevil/tutorial-qgis-maxent/blob/master/screenshots/qgis_data-prep-04.png)

	

    -

	- Next, go to **`Processing > Toolbox`** menu, which opens the `Processing Toolbox` panel. Search for the `Clip raster with polygon` function under the SAGA geoalgorithms and select this function. This will open the **`Clip Raster with Polygon`** dialog box.

      + Under the `Input` drop-down menu, click `...` and navigate through your working directory and select one of the raster layers, say **biol1_210.tif**.
      + Under the `Polygons` input line, select the **box.shp** shapefile from the drop-down menu. The rasters will be clipped using the extent of this polygon.
      + Under the `Clipped` input line, click `...` and select **`Save to File`** from the menu to save the file in your working directory using the same file name, but this time, change the output file type to **ASC** as this is the file type requirement used by MaxEnt. Then, click `Run` to generate the clipped raster file, **biol1_210.asc**.

    ![data-prep5](https://github.com/dondealban/tutorial-qgis-maxent/blob/master/screenshots/qgis_data-prep-05.png)

    Repeat this for all other raster layers by following the same process. You may also opt to run this through batch processing by clicking on the **`Run As a Batch Process...`** button.

2. Next, we will extract the occurrence points of the species we are interested in modeling.

    - Inspect the threatened tree species database using tools like R or Excel. For this exercise, let us model the distributions of `Cinnamomum mercadoi` that were observed in the Polillo Islands.

    - To select the species from the CSV file, we will use a few lines of code in R as follows:
    ```R
    # This line reads the CSV file and stores it in a variable
    # Note: change file path to your working directory
    data <- read.csv(file="Geoferenced_threatenedforesttreespecies.csv", header=TRUE, sep=",")

    # This line selects the species in our study area and stores it in a variable
    polillo_cm <- subset(data, Species=="Cinnamomum mercadoi" & Source=="Clements, 2001", select=c(2,10:11))

    # This line saves the selected species in a CSV file
    write.csv(polillo_cm, file="polillo_cm.csv", row.names=FALSE)
    ```

    Here, note that the search terms used include the species name and the source of the data based on the database. Also, only columns 2, 10, and 11 were selected and saved in the final CSV file, which corresponds to the columns 'Species', 'Lat', and 'Long'.

    Alternatively, you can download the [R script](https://github.com/dondealban/tutorial-qgis-maxent/blob/master/Select.Species.R) and run this in R or RStudio.

3. We are almost ready to create our first species distribution model. But before we do that, load all of the clipped environmental rasters and the species occurrence file in QGIS:

    - Load the clipped environmental raster layers by adding them from the **`Layer > Add Layer > Add Raster Layer...`** menu. Remember that these are the **.ASC** files.
    ![data-prep6](https://github.com/dondealban/tutorial-qgis-maxent/blob/master/screenshots/qgis_data-prep-06.png)

    - Load species occurrence data CSV file by adding it from the **`Layer > Add Layer > Add Delimited Text Layer...`** menu.
    ![data-prep7](https://github.com/dondealban/tutorial-qgis-maxent/blob/master/screenshots/qgis_data-prep-07.png)

    - In the **`Create a Layer from a Delimited Text File`** dialog box, select the CSV file by navigating to the file in your working directory. Once it is opened, the species records and their coordinates will be shown in the lower part of the dialog box. In the `X field` and `Y field` drop-down menus, select 'Long' and 'Lat' columns, respectively.
    ![data-prep8](https://github.com/dondealban/tutorial-qgis-maxent/blob/master/screenshots/qgis_data-prep-08.png)


<a name="model_species_distribution"></a>
## Model Species Distributions
We are now ready to create our first species distribution model using MaxEnt.

1. Open MaxEnt and load the `Samples` and `Environmental Layers` by navigating to the respective directories of those files. Ensure that the tick boxes of all files are checked, and that the `Environmental Layers` files are all 'Continuous' types.

![maxent1](https://github.com/dimEvil/tutorial-qgis-maxent/blob/master/screenshots/maxent_01.png)

2. Also, in the main MaxEnt window, check tick boxes or select the following options:

    - Linear/Quadratic/Product/Threshold/Hinge features
    - Create response curves
    - Make pictures of predictions
    - Do jackknife to measure variable importance
    - `Output format`: Logistic
    - `Output file type`: asc

Leave the other advanced settings in their default for now. Then, click `Run` and wait for the processing to finish.

3. Once the MaxEnt software completes its data processing:

    - Load the resulting **ASC** file in QGIS from the **`Layer > Add Layer > Add Raster Layer...`** menu. Then, change the styling of the raster layer by going to **`Layer > Properties...`** menu, or double-clicking on the layer under the `Layers Panel`. Change the styling of the raster layer as shown on the image below. Alternatively, you can also load the layer styling using this [QML](https://github.com/dondealban/tutorial-qgis-maxent/blob/master/sdm_logistic.qml) file (only applicable to the logistic model output).

    ![maxent2](https://github.com/dondealban/tutorial-qgis-maxent/blob/master/screenshots/maxent_02.png)

    The styling of the raster layer has been changed similar to the image below, which shows the logistic output of the MaxEnt's species distribution model.

    ![maxent3](https://github.com/dondealban/tutorial-qgis-maxent/blob/master/screenshots/maxent_03.png)

**Congratulations!** You have now made your first species distribution model using QGIS, R, and MaxEnt.


<a name="further_reading"></a>
## Further Reading
To learn more about MaxEnt such as analysing and interpreting MaxEnt's outputs, adjusting model settings, etc. the following materials are suggested for further reading:

Elith, J., Graham, C.H., Anderson, R.P., Dudik, M., Ferrier, S., Guisan, A., et al. (2006) Novel methods improve prediction of species’ distributions from occurrence data. Ecography, 29, 129–151. [(DOI)](https://dx.doi.org/10.1111/j.2006.0906-7590.04596.x)

Merow, C., Smith, M.J. & Silander, J.A. (2013) A practical guide to MaxEnt for modeling species’ distributions: what it does, and why inputs and settings matter. Ecography, 36, 1058–1069. [(DOI)](https://dx.doi.org/10.1111/j.1600-0587.2013.07872.x)

Morales, N.S., Fernandez, I.C. & Baca-Gonzalez, V. (2017) MaxEnt’s parameter configuration and small samples: are we paying attention to recommendations? A systematic review. PeerJ, 5, e3093. [(DOI)](https://dx.doi.org/10.7717/peerj.3093)

Phillips, S.J., Anderson, R.P., Dudik, M., Schapire, R.E. & Blair, M.E. (2017) Opening the black box: an open-source release of Maxent. Ecography, 40, 887–893.[(DOI)](https://dx.doi.org/10.1111/ecog.03049)

Phillips, S.J., Anderson, R.P. & Schapire, R.E. (2006) Maximum entropy modeling of species geographic distributions. Ecological Modelling, 190, 231–259. [(DOI)](https://dx.doi.org/10.1016/j.ecolmodel.2005.03.026)

Yackulic, C.B., Chandler, R., Zipkin, E.F., Royle, J.A., Nichols, J.D., Campbell Grant, E.H. & Veran, S. (2013) Presence-only modelling using MAXENT: when can we trust the inferences? Methods in Ecology and Evolution, 4, 236–243. [(DOI)](https://dx.doi.org/10.1111/2041-210x.12004)


<a name="references"></a>
## References

<a name="hijmans_etal_2005"></a>
Hijmans, R.J., Cameron, S.E., Parra, J.L., Jones, P.G. & Jarvis, A. (2005) Very high resolution interpolated climate surfaces for global land areas. *International Journal of Climatology*, 25, 1965–1978. [(DOI)](https://dx.doi.org/10.1002/joc.1276)

<a name="ramos_etal_2011"></a>
Ramos, L.T., Torres, A.M., Pulhin, F.B. & Lasco, R.D. (2011) Developing a georeferenced database of selected threatened forest tree species in the Philippines. *Philippine Journal of Science*, 141, 165–177. [(PDF)](http://philjournalsci.dost.gov.ph/pdf/pjs%20pdf/vol141no2/pdf/Developing_a_Georeferenced_Database.pdf)

<a name="stattersfield_etal_1998"></a>
Stattersfield, A.J., Crosby, M., Long, A.J. & Wege, D.C. (1998) *Endemic Bird Areas of the World: Priorities for Biodiversity Conservation*. The Burlington Press, Ltd., Cambridge, United Kingdom.


<a name="license"></a>
## License
Creative Commons Attribution 4.0 International [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). Please note the Disclaimer of Warranties and Limitation of Liability under Section 5 of this license as follows:

> a. Unless otherwise separately undertaken by the Licensor, to the extent possible, the Licensor offers the Licensed Material as-is and as-available, and makes no representations or warranties of any kind concerning the Licensed Material, whether express, implied, statutory, or other. This includes, without limitation, warranties of title, merchantability, fitness for a particular purpose, non-infringement, absence of latent or other defects, accuracy, or the presence or absence of errors, whether or not known or discoverable. Where disclaimers of warranties are not allowed in full or in part, this disclaimer may not apply to You.
>
> b. To the extent possible, in no event will the Licensor be liable to You on any legal theory (including, without limitation, negligence) or otherwise for any direct, special, indirect, incidental, consequential, punitive, exemplary, or other losses, costs, expenses, or damages arising out of this Public License or use of the Licensed Material, even if the Licensor has been advised of the possibility of such losses, costs, expenses, or damages. Where a limitation of liability is not allowed in full or in part, this limitation may not apply to You.
>
> c. The disclaimer of warranties and limitation of liability provided above shall be interpreted in a manner that, to the extent possible, most closely approximates an absolute disclaimer and waiver of all liability.

<a name="contribute"></a>
## Want to Contribute?
In case you wish to contribute or suggest changes, please feel free to fork this repository. Commit your changes and submit a pull request. Thanks.
