library(dplyr)
library(ggplot2)
library(ggalluvial)
library(ggthemes)
library(scales)
library(rcartocolor)
library(viridisLite)

# 1. Load dataframes ----
country_monthly_ranked <- read.csv("https://raw.githubusercontent.com/viriyatae/pandemictweets/main/country_monthly_ranked.csv?token=ABXC5QRICUN7EN6AFWXYHBLBKWUWE") %>%
        mutate(date = as.Date(date))
topic_monthly_ranked = read.csv("https://raw.githubusercontent.com/viriyatae/pandemictweets/main/topic_monthly_ranked.csv?token=ABXC5QTUXE6KVOU7NQZV5HTBKWVLQ") %>%
        mutate(date = as.Date(date))

# 2. Plot monthly tweets by country ----
ggplot(country_monthly_ranked, aes(x = date, y = freq, alluvium = country)) +
        geom_alluvium(aes(fill = country),
                      alpha = .8, decreasing = FALSE) +
        scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
        scale_x_date(expand= expansion(mult = c(0,0),
                                       add = c(0,1)),
                     breaks = scales::pretty_breaks(n = 7)) +
        ylab("Number of Tweets (Monthly) by Country") +
        scale_fill_carto_d(type = "qualitative", palette = "Safe") +
        theme_light() +
        theme(axis.title.x = element_blank(),
              legend.title = element_blank(),
              panel.grid.minor.x = element_blank(),
              panel.grid.minor.y = element_blank())

# 3. Plot monthly tweets by topic ----
ggplot(topic_monthly_ranked, aes(x = date, y = freq, alluvium = topic)) +
        geom_alluvium(aes(fill = topic),
                      alpha = .9, decreasing = FALSE) +
        scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
        scale_x_date(expand= expansion(mult = c(0,0),
                                       add = c(0,1))) +
        ylab("Number of Tweets by Topic") +
        scale_fill_viridis_d(option = "turbo") +
        scale_size(guide = "none",
                   range = c(1, 10)) +
        theme_light() +
        theme(axis.title.x = element_blank())


