---
output:
  pdf_document: default
  html_document: default
---
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


There are two types of datasets required in MaxEnt; the species occurrence records and environmental covariates. Occurrence records are geographic points (i.e. coordinates) of species observation while environmental covariates are set of data that contains continuous or categorical values such as temperature, precipitation and land cover (for details see Pearson, 2007). To perform the modeling in MaxEnt, species occurrence should be in comma separated values (CSV) and covariates should be in raster Arc/Info ASCII Grid format.

1. **Species occurrence data.** The species occurrence records are the geographic point locations or coordinates of species observations. For this exercise, we will use data downloaded from [GBIF](www.gbif.org). For this tutorial we used this dataset [data](https://doi.org/10.15468/dl.cu4aii) (249 KB, CSV file) [Papilio machaon](https://en.wikipedia.org/wiki/Papilio_machaon) occurrences in Flanders, Belgium. The dataset only holds occurrences between 1960 and 1990, because of the WorldClim data available. 

	- create a folder for csv's and place the occurrence data there. Name your folder [csv]
	- in GBIF, query for `species: Papilio machaon`  
	- in GBIF, query for `country or area: Belgium`
	- in GBIF, query for `year between 1960 and 1990`
	- download and name your file Papilio_machaon 
		
You can also find the file [here](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/csv/Papilio_machaon.csv).


	
2. **Environmental predictors.** The environmental covariates consist of raster data that contain either continuous or categorical values such as precipitation, temperature, elevation, etc. We will be using the [WorldClim](http://www.worldclim.org) raster datasets. WorldClim is a set of gridded global climate data layers, which can be used for mapping and ecological modeling. For this exercise, we will use [WorldClim v.1.4 Current conditions](http://www.worldclim.org/current) (or interpolations of observed data from 1960-1990). We will need the highest resolution data available provided at 30 arc-seconds (~1 km);  You can read [Hijmans et al. (2005)](#hijmans_etal_2005) for more information about the climate data layers. The WorldClim 0.5 (Bio16_zip) dataset for Europe can be downloaded [here](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/rasters/wc0.5_europe/bio_16.zip) for present data.

One variable, used frequently in niche modeling is the altitude. The altitude is not included in the WorldClim dataset. We can use the GTOPO30 dataset. It will provide us the altitude information on a similar resolution. The GTOP30 data can be downloaded [here](https://lta.cr.usgs.gov/GTOPO30). You should go to [earthExplorer](https://earthexplorer.usgs.gov/). You have to create a login and download the data.

   - create folder for your raster data.Name your folder [rasters]
   - next, we will unzip the bio_16.zip file in the appropriate folder.
   - download the topodata from earthExplorer or alternatively find it [here:] (https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/rasters/wc0.5_europe/gt30w020n90.tif)



![data-prep](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/screenshots/qgis_data-prep-create-geotiff.PNG)


To prepare the datasets, we will also need **administrative boundary** data. We can use the administrative boundary vector data from the [Global Administrative Database](http://www.gadm.org/country). On GADM's Download page, select "Belgium" and "Shapefile" from the *Country* and *Format* drop-down menus, respectively, and click the
[download](http://biogeo.ucdavis.edu/data/gadm2.8/shp/PHL_adm_shp.zip) link provided (~22 MB, ZIP file). For this exercise we will use this file [FlandersWGS84](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/shp/Belgium/Vlaanderen_WGS84-20180703T080424Z-001.zip)

  -download the [FlandersWGS84] file in your raster folder


`Alternatively you can draw a polygon which you can use for creating the training area for niche modeling. Your training area shape should contain all the occurrences you need to use for your niche modeling. You need to save this polygon as a .shp file so you can clip the environmental raster data correctly.`



## Study Area
**Belgium** Belgium (/ˈbɛldʒəm/ (About this sound listen) BEL-jəm),[A] officially the Kingdom of Belgium, is a country in Western Europe bordered by France, the Netherlands, Germany and Luxembourg. A small and densely populated country, it covers an area of 30,528 square kilometres (11,787 sq mi) and has a population of more than 11 million. Straddling the cultural boundary between Germanic and Latin Europe, Belgium is home to two main linguistic groups: the Dutch-speaking, mostly Flemish community, which constitutes about 59 percent of the population, and the French-speaking, mostly Walloon population, which comprises about 40 percent of all Belgians. Additionally, there is a small ~1 percent group of German speakers who live in the East Cantons.

**Flanders** Flanders (Dutch: Vlaanderen [ˈvlaːndərə(n)] (About this sound listen), French: Flandre [flɑ̃dʁ], German: Flandern [ˈflandɐn]) is the Dutch-speaking northern portion of Belgium, although there are several overlapping definitions, including ones related to culture, language, politics and history. It is one of the communities, regions and language areas of Belgium. The demonym associated with Flanders is Fleming, while the corresponding adjective is Flemish. The official capital of Flanders is Brussels,[1] although the Brussels Capital Region has an independent regional government, and the government of Flanders only oversees the community aspects of Flanders life there such as (Flemish) culture and education.



![study-area](https://github.com/dimEvil/tutorial-qgis-maxent/blob/master/poster/N2000Belgium.jpg)
  *note* The study area should never be dependent on country borders. the study area needs to contain validated occurrences of the species modelled.


## Prepare Datasets

### Preparing the Study area

#### Option 1: Create Flanders bouding box in Qgis to clip Raster files

1. First, we will create subsets from the environmental rasters to focus our modeling over our study area. To do this, we will create a polygon shapefile containing the extent of the study area and use this shapefile to clip all the raster map layers. Follow these steps using QGIS:

  - in Qgis, load the **vlaanderen_wgs84.shp** [shapefile](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/shp/Flanders/Vlaanderen_WGS84.shp) by adding a vector layer from the **`Layer > Add Layer > Add Vector Layer...`** menu. This displays the municipal-level administrative boundaries. Make sure the shapefile you will use has the correct SRS. In most cases WGS84.

![data-prep1](https://github.com/dimevil/tutorial-qgis-maxent/blob/master/screenshots/qgis_data-prep-01a.png)

Next, we will create a polygon from the extent of the Flanders shapefile that we have just saved. 
  - go to **`Vector > Research Tools > Polygon from Layer Extent`** menu.
  - under the `Input Layer` drop-down menu, select the newly created **vlaanderen_wgs84.shp** shapefile.
  - under the `Extent` input line, select **`Save to File`** from the menu to save the file in your working directory. Then, click `Run` to create another shapefile called **box1.shp**, which consists of a polygon covering the extent of the study area.

![data-prep4](https://github.com/dimevil/tutorial-qgis-maxent/blob/master/screenshots/qgis_data-prep-04.png)
    
We have created a bounding box of Flanders, this box **can** be used as the polygon to clip the raster files.     
    
![data-prepbox](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/screenshots/qgis_data-prep-box1.PNG)
    


#### Option 2: Draw your own training polygon in Qgis to clip raster files

  - open your (cleaned) occurrences layes in Qgis
  - in Layers, choose Create "New shapefile"" layer
  - in the resulting window click the button for "polygon", click ok and name your polygon      `'Species_name'_TrainingRegionFlanders`
  
  ![CreatePolygon](https://github.com/dimevil/tutorial-qgis-maxent/blob/master/screenshots/Qgis_data-prep-create-polygon.PNG)
  
  - select your new layer (is highlighted) in the panels section
  - hit the Edit button
  - choose "Create new polygon" button
  - draw your Training Area

Every time you left click on the map, a dot will be created. QGIS will draw lines to connect these dots to create a polygon. If you mis-click, do not worry - you will be able to move points to the appropriate place.

  - right click anywhere on the map, leave inout an ID blank and hit OK
  - click on the "node" tool to edit your training layer
  - save layer as shapefile

  ![CreatePolygon](https://github.com/dimevil/tutorial-qgis-maxent/blob/master/screenshots/Qgis_data-prep-create-polygon2.PNG)


You can find a usable training region for Flanders (here)[https://github.com/DimEvil/tutorial-qgis-maxent/tree/master/shp/trainingRegionFlanders]


#### Clipping RasterFiles (environmental data) with trainingRegion or bounding box

![data-prep5](https://github.com/dimevil/tutorial-qgis-maxent/blob/master//screenshots/Qgis_data-prep-clip-raster1.PNG)

  - next, go to **`Processing > Toolbox`** menu, which opens the `Processing Toolbox` panel. 
  - search for the `Clip raster with polygon` function under the SAGA geoalgorithms and select this function. This will open the **`Clip Raster with Polygon`** dialog box.
  - Under the `Input` drop-down menu, click `...` and navigate through your working directory and select one of the raster layers, say **biol1_210.tif**.
  - under the `Polygons` input line, select the **box1.shp** shapefile (or the training region shapefile) from the drop-down menu. The rasters will be clipped using the extent of this polygon. Alternatively, choose the training region you created.

You can also find the processed files here:
      
[Box1](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/shp/box/box1.shp)
[TrainingArea](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/shp/trainingRegionFlanders/papilio_trainingRegionFlandersWGS84.shp)

  - under the `Clipped` input line, click `...` and select **`Save to File`** from the menu to save the file in your working directory using the same file name, the output file type is **.tif** . Later we need to convert this file to *.ASC as this is the file type requirement used by MaxEnt. Then, click `Run` to generate the clipped raster file, **biol1_210.tif**.
      
  *Repeat this for all other raster layers by following the same process.*
    
# Converting the Tif files into *.asc files

Maxent is very picky when it comes to the format of the files we can use. for the raster data, all should have exact the same resolution, bounding box and should be in the *.asc format. For the worldclim data this is no problem. If you like to use the altidude in your model. You need to give the topology data some extra tweaks. This is because of all the conversions and rounding errors.

First, let's convert the clipped raster data, which is in .tif format to the *.asc format.

- in Qgis, go to raster --> conversion --> translate
- choose the tif you want to convert in "input layer"
- select outputlayer, name your file and choose .ASC as the extension
- make sure your target SRS is EPSG:4326
- select OK

![conversion](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/screenshots/convert_to_asc.PNG)
![conversion2](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/screenshots/convert_to_asc2.PNG)

If you want to use the altitude.asc file in your modeling, you need to open the translated altitude.asc file in a text editor [notepad++](https://notepad-plus-plus.org/download/v7.5.8.html) and make sure the bounding box is similar with the bounding box of the other climate variables.


#Extract the occurrence points of the species we are interested in modeling.

For niche modeling in Maxent we need species occurrence records. They should be in csv format and the separator should be ",".  Preparing this file can be done in many tools. We woudl like to recommend *R* , *Openrefine* or *LibreOffice* Using Ms Excel might cause problems as the encoding of the .csv files by excel is not always accepted by Maxent.

We need to be sure that all the occurrences we will use for our Niche modeling are within the training area. We will clean our occurrencs in Qgis.

 - open Qgis
 - load needed layers
      - shapefile (shp)
      - occurrences (csv)
      
![cleanCSV](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/screenshots/qgis_data-prep-cleanCSV.PNG)
 - save your .csv as a shapefile
      - right click on the layer
      - choose save as ESRI-shape file
      - choose the right folder
      - save as desired_name_shape
      - click add layer to map


      
- remove occurrences from a shapefile
      - click the Edit button
      - click select objects with one click
      - select the erroneous point
      - delete the point (del)
      - save your shapefile as a .csv (This is the file we will use for further processing)

![cleanCSV](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/screenshots/qgis_data-prep-cleanSHP.PNG)
![cleanCSV](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/screenshots/qgis_data-prep-cleanSHPEditButton.PNG)




## Further preparing your dataet in *R*

- Inspect the threatened species using tools like R or Openrefine. For this exercise, let us model the distributions of `Papilio_machaon` that were observed in Flanders.

- To select the species from the CSV file, you can use this R script.
    
[R script Papilio](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/script/R%20dataset%20manipulation%20Papilio_machaon.Rmd)
    
 - open R studio
 - start a new project in your maxent-Qgis directory
 - choose new R markdown file
 - copy paste the script in this file
 - make sure your folder structure is correct
        -[NichemodelingWorkshop]  [csv] -- [processed]
                                    |
                                  [rasters]
                                    |
                                  [script]
                                    |
                                  [Qgis]
                                    |
                                  [shapefiles]
                                    
 - run the script
    - the script basically reads the file you downloaded from GBIF
    - filters the data from 1960 to 1990 (this was already done in your GBIF download, it's an extra measure)
    - selects the columns needed for Maxent (scientificName, decimalLatitude and decimalLongitude)
    - and writes a csv file in a folder named processed

## Further preparing your data in *Openrefine*

In Openrefine 

  - start new project
  - choose file downloaded with GBIF
  - remove unneeded columns (All except scientificName, decimalLatitude, decimalLongitude)
    -in Column All, choose Re-order/Remove Columns
    -or remove every column manually
  - clean scientificName (only genus an speciesname needed)
  - export data as csv file
  
![removeColumns](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/screenshots/qgis_data-prep-remove_columns_Refine.PNG)



## Further preparing your data in a *worksheet*

- Clean your dataset
		- remove all occurrences which do not pertain to Flanders
		- remove all suspicious occurrences (occurrences in the ocean...)
		- check your desired occurrence precission
		- keep only scientificName, decimalLatitude & decimalLongitude
		
		


3. We are almost ready to create our first species distribution model. But before we do that, load all of the clipped environmental rasters and the species occurrence file in QGIS:

  - Load the clipped environmental raster layers by adding them from the **`Layer > Add Layer > Add Raster Layer...`** menu. Remember that these are the **.ASC** files.
   ![data-prep6](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/screenshots/qgis_data-prep-06.png)

    - Load species occurrence data CSV file by adding it from the **`Layer > Add Layer > Add Delimited Text Layer...`** menu.
    ![data-prep7](https://github.com/DimEvil/tutorial-qgis-maxent/blob/master/screenshots/qgis_data-prep-07.png)

    - In the **`Create a Layer from a Delimited Text File`** dialog box, select the CSV file by navigating to the file in your working directory. Once it is opened, the species records and their coordinates will be shown in the lower part of the dialog box. In the `X field` and `Y field` drop-down menus, select 'Long' and 'Lat' columns, respectively.
   

<a name="#model_species_distribution"></a>
## Model Species Distributions
We are now ready to create our first species distribution model using MaxEnt.

1. Open MaxEnt and load the `occurrences` and `Environmental Layers` by navigating to the respective directories of those files. Ensure that the tick boxes of all files are checked, and that the `Environmental Layers` files are all 'Continuous' types.

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

    - Load the resulting **ASC** file in QGIS from the **`Layer > Add Layer > Add Raster Layer...`** menu. Then, change the styling of the raster layer by going to **`Layer > Properties...`** menu, or double-clicking on the layer under the `Layers Panel`. Change the styling of the raster layer as shown on the image below.


    The styling of the raster layer has been changed similar to the image below, which shows the logistic output of the MaxEnt's species distribution model.

    ![maxent3](https://github.com/dimEvil/tutorial-qgis-maxent/blob/master/screenshots/maxent_03.png)

**Congratulations!** You have now made your first species distribution model using QGIS, R, and MaxEnt.


<a name="further_reading"></a>
## Further Reading
To learn more about MaxEnt such as analysing and interpreting MaxEnt's outputs, adjusting model settings, etc. the following materials are suggested for further reading:

Elith, J., Graham, C.H., Anderson, R.P., Dudik, M., Ferrier, S., Guisan, A., et al. (2006) Novel methods improve prediction of species’ distributions from occurrence data. Ecography, 29, 129–151. [(DOI)](https://dx.doi.org/10.1111/j.2006.0906-7590.04596.x)

Merow, C., Smith, M.J. & Silander, J.A. (2013) A practical guide to MaxEnt for modeling species’ distributions: what it does, and why inputs and settings matter. Ecography, 36, 1058–1069. [(DOI)](https://dx.doi.org/10.1111/j.1600-0587.2013.07872.x)

Morales, N.S., Fernandez, I.C. & Baca-Gonzalez, V. (2017) MaxEnt’s parameter configuration and small samples: are we paying attention to recommendations? A systematic review. PeerJ, 5, e3093. [(DOI)](https://dx.doi.org/10.7717/peerj.3093)

Phillips, S.J., Anderson, R.P., Dudik, M., Schapire, R.E. & Blair, M.E. (2017) Opening the black box: an open-source release of Maxent. Ecography, 40, 887–893.[(DOI)](https://dx.doi.org/10.1111/ecog.03049)

Phillips, S.J., Anderson, R.P. & Schapire, R.E. (2006) Maximum entropy modeling of species geographic distributions. Ecological modeling, 190, 231–259. [(DOI)](https://dx.doi.org/10.1016/j.ecolmodel.2005.03.026)

Yackulic, C.B., Chandler, R., Zipkin, E.F., Royle, J.A., Nichols, J.D., Campbell Grant, E.H. & Veran, S. (2013) Presence-only modeling using MAXENT: when can we trust the inferences? Methods in Ecology and Evolution, 4, 236–243. [(DOI)](https://dx.doi.org/10.1111/2041-210x.12004)


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
