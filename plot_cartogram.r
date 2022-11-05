library(cartogram)
library(tidyverse)
library(geojsonio)
library(ggplot2)
library(sf)

spdf <- geojson_read("aiueo_table.json", what = "sp")
stat <- read.table("stat.csv", sep = ",", header = TRUE)
spdf@data <- spdf@data %>% left_join(., stat, by = c("name" = "first_letter"))

sfno <- st_as_sf(spdf)
sfproj <- st_transform(sfno, crs = 6674)

windowsFonts(MEI = windowsFont("IPAexGothic"))
ggplot() +
    geom_sf(data = sfproj) +
    geom_sf_label(data = sfproj, aes(label = name), size = 8, family = "MEI", label.size = 0, fontface = "bold", alpha = 0.5, label.r = unit(0.4, "lines"), label.padding = unit(0.4, "lines")) +
    theme(text = element_text(size = 24), axis.ticks = element_blank(), axis.title = element_blank(), axis.text = element_blank())


cartogram <- cartogram_cont(sfproj, "count", itermax = 50)

ggplot() +
    geom_sf(data = cartogram, aes(fill = count)) +
    geom_sf_label(data = cartogram, aes(label = name), size = 8, family = "MEI", label.size = 0, fontface = "bold", alpha = 0.5, label.r = unit(0.4, "lines"), label.padding = unit(0.4, "lines")) +
    theme(text = element_text(size = 24), axis.ticks = element_blank(), axis.title = element_blank(), axis.text = element_blank())
