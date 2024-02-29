#!/bin/bash

# for i in ID geom X1990 X1991 X1992 X1993 X1994 X1995 X1996 X1997 X1998 X1999 X2000 X2001 X2002 X2003 X2004 X2005 X2006 X2007 X2008 X2009 X2010 X2011 X2012 X2013 X2014 X2015 X2016 X2017 X2018 X2019 
# do
#     echo ${i}_index
#     ogrinfo -sql "CREATE INDEX "${i}" ON QC_CUBE_Richesse_spe_10x10_wkt_raw_obs_SIMPL ("${i}")" /home/local/USHERBROOKE/juhc3201/BDQC-GEOBON/data/QUEBEC_in_a_cube/Richesse_spe/QC_CUBE_Richesse_spe_10x10_wkt_raw_obs_SIMPL.gpkg

# done

# ogrinfo -sql 

for file in QC_CUBE_Richesse_spe_N01_wkt_raw_obs_SIMPL QC_CUBE_Richesse_spe_N02_wkt_raw_obs_SIMPL QC_CUBE_Richesse_spe_N03_wkt_raw_obs_SIMPL QC_CUBE_Richesse_spe_N04_wkt_raw_obs_SIMPL
do
    echo ${file}
    for i in reg_name geom X1990 X1991 X1992 X1993 X1994 X1995 X1996 X1997 X1998 X1999 X2000 X2001 X2002 X2003 X2004 X2005 X2006 X2007 X2008 X2009 X2010 X2011 X2012 X2013 X2014 X2015 X2016 X2017 X2018 X2019
    do
        echo ${i}
        ogrinfo -sql "CREATE INDEX "${i}" ON "${file}" ("${i}")" /home/local/USHERBROOKE/juhc3201/BDQC-GEOBON/data/QUEBEC_in_a_cube/Richesse_spe/${file}.gpkg
    done
done