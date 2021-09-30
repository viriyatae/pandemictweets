# pandemictweets

<br/> tweet_full.csv
<br/> This is the dataset that contains 115,553 tweets that mentioned the 10 Southeast Asian countries from 22 January 2020 to 31 July 2021 

<br/> rowid: id of the tweet in the dataset
<br/> id_date: id of the tweets in a given day
<br/> date: date in d/m/y
<br/> tweetid: id no. of the tweet
<br/> Brunei: tweet contain the word "Brunei" (1 yes / 0 no)
<br/> Cambodia: tweet contain the word "Cambodia" (1 yes / 0 no)
<br/> Indonesia: tweet contain the word "Indonesia" (1 yes / 0 no)
<br/> Laos: tweet contain the word "Laos" (1 yes / 0 no)
<br/> Malaysia: tweet contain the word "Malaysia" (1 yes / 0 no)
<br/> Myanmar: tweet contain the word "Myanmar" (1 yes / 0 no)
<br/> Philippines: tweet contain the word "Philippines" (1 yes / 0 no)
<br/> Singapore: tweet contain the word "Singapore" (1 yes / 0 no)
<br/> Thailand: tweet contain the word "Thailand" (1 yes / 0 no)
<br/> Vietnam: tweet contain the word "Vietnam" (1 yes / 0 no)
<br/> word_scores: scoring of each word in the dataset by VADER sentiment algorithm
<br/> compound: compound VADER sentiment (from -1 negative to 1 positive)
<br/> pos: percentage of positive words (0-1) VADER
<br/> neu: percentage of neutral words (0-1) VADER
<br/> neg: percentage of negative words (0-1) VADER
<br/> but_count: counts of the word "but" VADER
<br/> anger: counts of words that elicit anger NRC
<br/> anticipation: counts of words that elicit anticipation NRC
<br/> disgust: counts of words that elicit disgust NRC
<br/> fear: counts of words that elicit fear NRC
<br/> joy: counts of words that elicit joy NRC
<br/> sadness: counts of words that elicit sadness NRC
<br/> surprise: counts of words that elicit surprise NRC
<br/> trust: counts of words that elicit trust NRC
<br/> negative: counts of words that elicit negative emotion NRC
<br/> positive: counts of words that elicit positive emotion NRC
<br/> Protection: probability that the tweet is in the "Protection" topic (0-1) LDA
<br/> Military: probability that the tweet is in the "Military" topic (0-1) LDA
<br/> Death: probability that the tweet is in the "Death" topic (0-1) LDA
<br/> Politics: probability that the tweet is in the "Politics" topic (0-1) LDA
<br/> Variant: probability that the tweet is in the "Variant" topic (0-1) LDA
<br/> Countries: probability that the tweet is in the "Countries" topic (0-1) LDA
<br/> Healthcare: probability that the tweet is in the "Healthcare" topic (0-1) LDA
<br/> Economy: probability that the tweet is in the "Economy" topic (0-1) LDA
<br/> Hope: probability that the tweet is in the "Hope" topic (0-1) LDA
<br/> Travel: probability that the tweet is in the "Travel" topic (0-1) LDA
<br/> Lockdown: probability that the tweet is in the "Lockdown" topic (0-1) LDA
<br/> Vaccine: probability that the tweet is in the "Vaccine" topic (0-1) LDA
<br/> topic: assignment of tweet to the 12 topics LDA
<br/> topic_n: topic name
<br/>
<br/> pandemic_tweets_sea.R
<br/> The R script file that helps visualise the topics, sentiment, and emotions of tweets


