library(dplyr)
library(ggplot2)
library(ggalluvial)
library(ggthemes)
library(ggrepel)
library(scales)
library(rcartocolor)
library(viridisLite)
library(xts)
library(magrittr)
library(tidyr)
library(lubridate)
library(ggpubr)

# 1. Load dataframes ----
tweet_full <- read.csv("tweet_full.csv") %>%
        mutate(date = dmy(date))

## Variables
country_names <- c("Brunei","Cambodia","Indonesia","Laos","Malaysia","Myanmar","Philippines","Singapore","Thailand","Vietnam")
lda_topic <- c("Protection","Military","Death","Politics","Variant","Countries","Healthcare","Economy","Hope","Travel","Lockdown","Vaccine")
lda_topic_reordered <- c("Military","Politics","Protection","Hope","Death","Variant","Economy","Healthcare","Lockdown","Vaccine","Countries","Travel")
nrc_sentiment <- c("anger","anticipation","disgust","fear","joy","sadness","surprise","trust","negative","positive")
nrc_sentiment_reordered <- c("fear","anger","surprise","trust","sadness","anticipation","disgust","joy")

# 2. Create an xts object ----
tweet_xts <- xts(tweet_full[,c("topic","compound",nrc_sentiment)], order.by = tweet_full$date)
## Creat a list of country xts
tweet_xts_list <- list()
for (i in 5:14) {
        tweet_xts_list[[i-4]] <- xts(tweet_full[which(tweet_full[,i] == 1),c("compound",nrc_sentiment)], order.by = tweet_full[which(tweet_full[,i] == 1),]$date)
}

# 3. Plot monthly tweets by country ----
## Perform a daily frequency count
xts_freq_list <- lapply(tweet_xts_list, FUN = function(y) apply.daily(y[,"compound"],FUN = function(x) round(sum(as.numeric(x), na.rm = TRUE) / mean(as.numeric(x), na.rm = TRUE) , 2)))

## Create a dataframe from it
xts_freq_df <- do.call(cbind.xts,xts_freq_list) %>% set_colnames(country_names)

## Replace NA and NaN
coredata(xts_freq_df)[is.na(xts_freq_df) | is.nan(xts_freq_df)] <- 0

## Create a monthly frequency dataframe
xts_freq_df <- apply.monthly(xts_freq_df, apply, 2, sum)
time(xts_freq_df) <- lubridate::floor_date(time(xts_freq_df), unit = "month")

## Transform to a long format
freq_df <- xts_freq_df %>% as.data.frame() %>% mutate(date = rownames(.)) %>%
        pivot_longer(cols = 1:10, names_to = "country", values_to = "freq") %>%
        mutate(date = ymd(date)) %>%
        mutate(country = factor(country, levels = country_names))

## Create a rank of each month and reorder countries based on the final month
freq_df_rank <- freq_df %>% group_by(date) %>%
        mutate(rank = order(order(freq, decreasing=TRUE))) 
freq_df_tail <- freq_df_rank %>% tail(10) %>% arrange(rank)
freq_df_rank <- freq_df_rank %>%
        mutate(country = factor(country, levels = freq_df_tail$country))

## Plot
ggplot(freq_df_rank, aes(x = date, y = freq, alluvium = country)) +
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

# 4. Plot monthly tweets by topic ----
## Perform a monthly frequency count by topic
tweet_topic_monthly <- apply.monthly(tweet_xts[,"topic"], FUN = function(x) table(x$topic)) %>%
        set_colnames(lda_topic)
## Set the time to be the beginning of the month
time(tweet_topic_monthly) <- lubridate::floor_date(time(tweet_topic_monthly), unit = "month")

## Transform to a long format
alluvial_topic <- tweet_topic_monthly %>% as.data.frame() %>% mutate(date = rownames(.)) %>%
        pivot_longer(cols = 1:length(lda_topic), names_to = "topic", values_to = "freq")

## Create a rank of each month and reorder countries based on the final month
alluvial_topic_rank <- alluvial_topic %>% group_by(date) %>%
        mutate(rank = order(order(freq, decreasing=TRUE))) %>%
        mutate(date = ymd(date)) 
alluvial_topic_tail <- alluvial_topic_rank %>% tail(length(lda_topic)) %>% arrange(rank)
alluvial_topic_rank <- alluvial_topic_rank %>%
        mutate(topic = factor(topic, levels = alluvial_topic_tail$topic)) %>%
        mutate(topic = factor(topic, level = lda_topic_reordered))

## Plot
ggplot(alluvial_topic_rank, aes(x = date, y = freq, alluvium = topic)) +
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

# 5. Plot monthly average Vader sentiment by country ----
## Calculate average monthly VADER sentiment 
xts_vader_avg_list <- lapply(tweet_xts_list, FUN = function(y) apply.monthly(y[,"compound"],FUN = colMeans))
for (i in 1:10) {
        time(xts_vader_avg_list[[i]]) <- lubridate::floor_date(time(xts_vader_avg_list[[i]]), unit = "month")
}

## Combine xts
xts_vader_avg <- do.call(cbind.xts,xts_vader_avg_list) %>% set_colnames(country_names)

## Replace NA and NaN
coredata(xts_vader_avg)[is.na(xts_vader_avg) | is.nan(xts_vader_avg)] <- 0

## Create a dataframe
vader_avg_df <- xts_vader_avg %>% as.data.frame() %>% mutate(date = rownames(.)) %>%
        pivot_longer(cols = 1:10, names_to = "country", values_to = "sentiment") %>%
        mutate(date = ymd(date)) %>%
        mutate(country = factor(country, levels = freq_df_tail$country))

## Data preparation
vader_avg_rank <- tail(vader_avg_df, 10)
vader_avg_rank[,3] <- c(0.084,0.002,-0.026,0.06,0.028,-0.287,0.103,0.029,0.003,-0.04)

## Plot
ggplot(vader_avg_df, aes(x = date, y = sentiment, color = country, group = country)) +
        geom_smooth(method = "loess", se = FALSE) +
        ggrepel::geom_text_repel(data = vader_avg_rank,
                                 mapping = aes(label = country, y = sentiment), 
                                 nudge_x = 30, 
                                 size = 3, 
                                 point.padding = 0.5,
                                 direction = "y") +
        theme_light() +
        ylab("Sentiment level") +
        scale_x_date(expand = expansion(mult = c(0,0),
                                        add = c(0,60)),
                     breaks = scales::pretty_breaks(n = 7)) +
        theme(axis.title.x = element_blank(),
              legend.title = element_blank(),
              legend.position = "none",
              panel.grid.minor.x = element_blank(),
              panel.grid.minor.y = element_blank()) +
        scale_color_carto_d(type = "qualitative", palette = "Safe")

# 6. Alluvial plots by topic and country ----
## Create a list of tweets by country
tweet_list <- list()
for (i in 5:14) {
        tweet_list[[i-4]] <- tweet_full[which(tweet_full[,i] == 1),]
}

## Transform to xts
tweet_country_xts_list <- list()
for (i in 1:10) {
        tweet_country_xts_list[[i]] <- xts(tweet_list[[i]][,c("topic","compound",nrc_sentiment)], order.by = tweet_list[[i]]$date, origin="2020-01-01")
}

## Perform a monthly count
xts_topic_list <- lapply(tweet_country_xts_list, FUN = function(y){ apply.monthly(y[,"topic"],FUN = function(x) table(factor(x$topic, level = 1:length(lda_topic)))) %>% set_colnames(lda_topic)})

## Create a dataframe for plotting
alluvial_topic_country <- list()
for (i in 1:10){
        alluvial_topic_country[[i]] <- xts_topic_list[[i]] %>% as.data.frame() %>% mutate(date = rownames(.)) %>%
                pivot_longer(cols = 1:length(unique(lda_topic)), names_to = "topic", values_to = "freq") %>%
                mutate(date = ymd(date)) %>%
                mutate(topic = factor(topic, level = lda_topic_reordered))
}

## Loop plots 
plot_topic_alluvial <- list()
for (i in 1:10){
        plot_topic_alluvial[[i]] <- ggplot(alluvial_topic_country[[i]], aes(x = date, y = freq, alluvium = topic)) +
                geom_alluvium(aes(fill = topic),
                              alpha = .9, decreasing = FALSE) +
                scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
                scale_x_date(expand= expansion(mult = c(0,0),
                                               add = c(0,15)),
                             breaks = scales::pretty_breaks(n = 7)) +
                ggtitle(country_names[i]) +
                ylab("Number of Tweets") +
                scale_fill_viridis_d(option = "turbo") +
                theme_light() +
                theme(axis.title.x = element_blank(),
                      legend.text = element_text(size = 14),
                      panel.grid.minor.x = element_blank(),
                      panel.grid.minor.y = element_blank())
}

## Combine plots
plot_topic_alluvial_by_country <- ggarrange(plot_topic_alluvial[[1]], plot_topic_alluvial[[2]], plot_topic_alluvial[[3]], plot_topic_alluvial[[4]], plot_topic_alluvial[[5]],
                                            plot_topic_alluvial[[6]], plot_topic_alluvial[[7]], plot_topic_alluvial[[8]], plot_topic_alluvial[[9]], plot_topic_alluvial[[10]],
                                            ncol = 2, nrow=5, common.legend = TRUE, legend="bottom")

## Display a combined plot
plot_topic_alluvial_by_country

# 7. NRC Emotions ---
## Perform an emotion count by month
xts_nrc_df <- apply.monthly(tweet_xts[,3:10], FUN = colSums)
time(xts_nrc_df) <- lubridate::floor_date(time(xts_nrc_df), unit = "month")

## Transform to a dataframe
nrc_df <- xts_nrc_df %>% as.data.frame() %>% mutate(date = rownames(.)) %>%
        pivot_longer(cols = 1:8, names_to = "emotion", values_to = "count") %>%
        mutate(date = ymd(date)) %>%
        mutate(emotion = factor(emotion, levels = nrc_sentiment_reordered))

## Create a rank of each month and reorder countries based on the final month
nrc_df_rank <- nrc_df %>% group_by(date) %>%
        mutate(rank = order(order(count, decreasing=TRUE))) 
nrc_df_tail <- nrc_df_rank %>% tail(8) %>% arrange(rank)
nrc_df_rank <- nrc_df_rank %>%
        mutate(emotion = factor(emotion, levels = nrc_sentiment_reordered))

## Plot
ggplot(nrc_df_rank, aes(x = date, y = count, alluvium = emotion)) +
        geom_alluvium(aes(fill = emotion),
                      alpha = .8, decreasing = FALSE) +
        scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
        scale_x_date(expand= expansion(mult = c(0,0),
                                       add = c(0,1)),
                     breaks = scales::pretty_breaks(n = 7)) +
        ylab("Number of emotion counts (Monthly") +
        #scale_fill_brewer(palette = "Paired") +
        scale_fill_viridis_d(option = "plasma") +
        theme_light() +
        theme(axis.title.x = element_blank(),
              legend.title = element_blank(),
              panel.grid.minor.x = element_blank(),
              panel.grid.minor.y = element_blank())

# 8. Alluvial plots by emotion and country ---- 
## Remove positive and negative
xts_nrc_list_noposneg <- lapply(tweet_country_xts_list, FUN = function(y) apply.monthly(y[,3:10],FUN = colSums))

## Set time to the beginning of the month
for (i in 1:length(country_names)){
        time(xts_nrc_list_noposneg[[i]]) <- lubridate::floor_date(time(xts_nrc_list_noposneg[[i]]), unit = "month")
}

## Creat alluvial list
alluvial_nrc_country <- list()

## Create alluvial df
for (i in 1:10){
        alluvial_nrc_country[[i]] <- xts_nrc_list_noposneg[[i]] %>% as.data.frame() %>% mutate(date = rownames(.)) %>%
                pivot_longer(cols = 1:(length(nrc_sentiment)-2), names_to = "emotion", values_to = "freq") %>%
                mutate(date = ymd(date)) %>%
                mutate(emotion = factor(emotion, levels = nrc_sentiment_reordered))
}

## Loop alluvial plots 
plot_nrc_alluvial <- list()
for (i in 1:10){
        plot_nrc_alluvial[[i]] <- ggplot(alluvial_nrc_country[[i]], aes(x = date, y = freq, alluvium = emotion)) +
                geom_alluvium(aes(fill = emotion),
                              alpha = .9, decreasing = FALSE) +
                scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
                scale_x_date(expand= expansion(mult = c(0,0),
                                               add = c(0,15)),
                             breaks = scales::pretty_breaks(n = 7)) +
                ggtitle(country_names[i]) +
                ylab("Emotion counts") +
                scale_fill_viridis_d(option = "plasma") +
                theme_light() +
                theme(axis.title.x = element_blank(),
                      legend.text = element_text(size = 14),
                      panel.grid.minor.x = element_blank(),
                      panel.grid.minor.y = element_blank())
        
}

## Combine plots
plot_nrc_alluvial_by_country <- ggarrange(plot_nrc_alluvial[[1]], plot_nrc_alluvial[[2]], plot_nrc_alluvial[[3]], plot_nrc_alluvial[[4]], plot_nrc_alluvial[[5]],
                                          plot_nrc_alluvial[[6]], plot_nrc_alluvial[[7]], plot_nrc_alluvial[[8]], plot_nrc_alluvial[[9]], plot_nrc_alluvial[[10]],
                                          ncol = 2, nrow=5, common.legend = TRUE, legend="bottom")

## Display a combined plot
plot_nrc_alluvial_by_country

