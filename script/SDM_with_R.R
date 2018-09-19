library(dismo)
library (rgbif)
library(ggplot2)
library(dplyr)
library(sp)
library(maptools)

key <- name_backbone(name='Solanum acaule')$speciesKey
dat <- occ_search(taxonKey=key, return='data', limit=2000)
#gbifmap(dat)

SpMD <- dat %>%
  select(decimalLongitude, decimalLatitude, name, countryCode, year) %>%
  distinct(decimalLongitude,decimalLatitude, .keep_all = TRUE) %>%
  filter(!is.na(decimalLongitude)) %>%
  filter(countryCode == "AR" | countryCode ==  "BO" | countryCode == "PE" | countryCode == "EC") 

SpMDMap <- dat %>%
  distinct(decimalLongitude,decimalLatitude, .keep_all = TRUE)


 data(wrld_simpl)
 plot(wrld_simpl, xlim=c(-80,70), ylim=c(-60,10), axes=TRUE, col="light yellow")
# restore the box around the map
   box()
# plot points
  points(SpMD$decimalLongitude, SpMD$decimalLatitude, col='orange', pch=20, cex=0.75)
# plot points again to add a border, for better visibility
  points(SpMD$decimalLongitude, SpMD$decimalLatitude, col='red', cex=0.75)
  plot(wrld_simpl, add=T, border='blue', lwd=2)
  points(SpMD$decimalLongitude, SpMD$decimalLatitude, col='yellow', pch=20, cex=0,5)

  coordinates(SpMD) <- ~decimalLongitude+decimalLatitude
  crs(SpMD) <- crs(wrld_simpl)
  class(SpMD)
  class(wrld_simpl)
  
  
  ovr <- over(SpMD, wrld_simpl)
  plot(SpMD)
  plot(wrld_simpl, add=T, border='blue', lwd=2)
  points(acg[j, ], col='red', pch=20, cex=2)
  
  # create a RasterLayer with the extent of acgeo
    r <- raster(SpMD)
  # set the resolution of the cells to (for example) 1 degree
    res(r) <- 1
  # expand (extend) the extent of the RasterLayer a little
    r <- extend(r, extent(r)+1)
  # sample:
    acsel <- gridSample(SpMD, r, n=1)
  # to illustrate the method and show the result
    p <- rasterToPolygons(r)
    plot(p, border='gray')
    points(SpMD)
    # selected points in red
    points(acsel, cex=1, col='red', pch='x')
  
write.csv(acsel, file = "acselRasterData.csv")
write.csv(acsel, file = "acaule.csv")

file <- paste(system.file(package="dismo"), '/ex/acaule.csv', sep='')
ac <- read.csv(file)

 # get the file names
   files <- list.files(path=paste(system.file(package="dismo"), '/ex', sep=''), pattern='grd', full.names=TRUE )
 # we use the first file to create a RasterLayer
   mask <- raster(files[1])
 # select 500 random points
   # set seed to assure that the examples will always
   # have the same random sample.
  set.seed(1963)
bg <- randomPoints(mask, 500 )

# set up the plotting area for two maps
  par(mfrow=c(1,2))
  plot(!is.na(mask), legend=FALSE)
  points(bg, cex=0.5)
# now we repeat the sampling, but limit
# the area of sampling using a spatial extent
   e <- extent(-80, -53, -39, -22)
 bg2 <- randomPoints(mask, 50, ext=e)
 plot(!is.na(mask), legend=FALSE)
 plot(e, add=TRUE, col='red')
 points(bg2, cex=0.5)

 coordinates(ac) <- ~lon+lat
 projection(ac) <- CRS('+proj=longlat +datum=WGS84')
 
# circles with a radius of 50 km
   x <- circles(ac, d=50000, lonlat=TRUE)
   pol <- polygons(x)
   
# sample randomly from all circles
  samp1 <- spsample(pol, 250, type='random', iter=25)
# get unique cells
  cells <- cellFromXY(mask, samp1)
  length(cells)
  
  cells <- unique(cells)
 
  xy <- xyFromCell(mask, cells)
  
  plot(pol, axes=TRUE)
  points(xy, cex=0.75, pch=20, col='blue')
  
  spxy <- SpatialPoints(xy, proj4string=CRS('+proj=longlat +datum=WGS84'))
  o <- over(spxy, geometry(x))
  xyInside <- xy[!is.na(o), ]
  
  
  
# extract cell numbers for the circles
  v <- extract(mask, x@polygons, cellnumbers=T)
# use rbind to combine the elements in list v
  v <- do.call(rbind, v)
# get unique cell numbers from which you could sample
   v <- unique(v[,1])
   head(v)
 
# to display the results
      m <- mask
    m[] <- NA
    m[v] <- 1
    plot(m, ext=extent(x@polygons)+1)
    plot(x@polygons, add=T)
   
files <- list.files(path=paste(system.file(package="dismo"), '/ex', sep=''), pattern='grd', full.names=TRUE )
# The above finds all the files with extension "grd" in the
# examples ("ex") directory of the dismo package. You do not
# need such a complex statement to get your own files.
files

names(predictors)

plot(predictors)
predictors <- stack(files)

library(maptools)
data(wrld_simpl)
file <- paste(system.file(package="dismo"), "/ex/bradypus.csv", sep="")
bradypus <- read.table(file, header=TRUE, sep=',')
# we do not need the first column
bradypus <- bradypus[,-1]

# first layer of the RasterStack
plot(predictors, 1)
# note the "add=TRUE" argument with plot
plot(wrld_simpl, add=TRUE)
# with the points function, "add" is implicit
points(bradypus, col='blue')

presvals <- extract(predictors, bradypus)
# setting random seed to always create the same
# random set of points for this example
set.seed(0)
 backgr <- randomPoints(predictors, 500)
 absvals <- extract(predictors, backgr)
 pb <- c(rep(1, nrow(presvals)), rep(0, nrow(absvals)))
 sdmdata <- data.frame(cbind(pb, rbind(presvals, absvals)))
 sdmdata[,'biome'] = as.factor(sdmdata[,'biome'])
 head(sdmdata)

 
# pairs plot of the values of the climate data
# at the bradypus occurrence sites.
 pairs(sdmdata[,2:5], cex=0.1, fig=TRUE)
 
