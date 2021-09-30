# pandemictweets

tweet_full.csv
This is the dataset that contains 115,553 tweets that mentioned the 10 Southeast Asian countries from 22 January 2020 to 31 July 2021 

rowid: id of the tweet in the dataset
id_date: id of the tweets in a given day
date: date in d/m/y
tweetid: id no. of the tweet
Brunei: tweet contain the word "Brunei" (1 yes / 0 no)
Cambodia: tweet contain the word "Cambodia" (1 yes / 0 no)
Indonesia: tweet contain the word "Indonesia" (1 yes / 0 no)
Laos: tweet contain the word "Laos" (1 yes / 0 no)
Malaysia: tweet contain the word "Malaysia" (1 yes / 0 no)
Myanmar: tweet contain the word "Myanmar" (1 yes / 0 no)
Philippines: tweet contain the word "Philippines" (1 yes / 0 no)
Singapore: tweet contain the word "Singapore" (1 yes / 0 no)
Thailand: tweet contain the word "Thailand" (1 yes / 0 no)
Vietnam: tweet contain the word "Vietnam" (1 yes / 0 no)
word_scores: scoring of each word in the dataset by VADER sentiment algorithm
compound: compound VADER sentiment (from -1 negative to 1 positive)
pos: percentage of positive words (0-1) VADER
neu: percentage of neutral words (0-1) VADER
neg: percentage of negative words (0-1) VADER
but_count: counts of the word "but" VADER
anger: counts of words that elicit anger NRC
anticipation: counts of words that elicit anticipation NRC
disgust: counts of words that elicit disgust NRC
fear: counts of words that elicit fear NRC
joy: counts of words that elicit joy NRC
sadness: counts of words that elicit sadness NRC
surprise: counts of words that elicit surprise NRC
trust: counts of words that elicit trust NRC
negative: counts of words that elicit negative emotion NRC
positive: counts of words that elicit positive emotion NRC
Protection: probability that the tweet is in the "Protection" topic (0-1) LDA
Military: probability that the tweet is in the "Military" topic (0-1) LDA
Death: probability that the tweet is in the "Death" topic (0-1) LDA
Politics: probability that the tweet is in the "Politics" topic (0-1) LDA
Variant: probability that the tweet is in the "Variant" topic (0-1) LDA
Countries: probability that the tweet is in the "Countries" topic (0-1) LDA
Healthcare: probability that the tweet is in the "Healthcare" topic (0-1) LDA
Economy: probability that the tweet is in the "Economy" topic (0-1) LDA
Hope: probability that the tweet is in the "Hope" topic (0-1) LDA
Travel: probability that the tweet is in the "Travel" topic (0-1) LDA
Lockdown: probability that the tweet is in the "Lockdown" topic (0-1) LDA
Vaccine: probability that the tweet is in the "Vaccine" topic (0-1) LDA
topic: assignment of tweet to the 12 topics LDA
topic_n: topic name

pandemic_tweets_sea.R
The R script file that helps visualise the topics, sentiment, and emotions of tweets


