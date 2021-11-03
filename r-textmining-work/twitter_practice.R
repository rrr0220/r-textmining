
rm(list=ls())
gc();  gc();

packageVersion("rtweet")
devtools::session_info()

twitter_token = create_token(
  app = APPNAME,
  consumer_key = CONSUMERKEY,
  consumer_secret = CONSUMERSECRET,
  access_token = ACCESSTOKEN,
  access_secret = ACCESSSECRET
  )

rt = search_tweets("三菱自動車", n=100, include_rts=FALSE)
rt$text

library(openxlsx)
wb <- createWorkbook()
addWorksheet(wb, 'tweet')
writeData(wb, sheet = 'tweet', x = rt, withFilter=F)
modifyBaseFont(wb, fontSize = 11, fontColour = "#000000", fontName = "Meiryo UI")
saveWorkbook(wb, "MMCtweet.xlsx", overwrite = T)

