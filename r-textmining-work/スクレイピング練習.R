rm(list=ls())
gc();  gc();


# スクレイピング実践 ---------------------------------------------------------------

library(rvest)

# URLを変数にしておく
kabu_url = "https://kabutan.jp/stock/kabuka?code=0000"

# スクレイピングしたいURLを読み込む
url_res = read_html(kabu_url)
url_res

# URLの読み込み結果から、title要素を抽出
url_title = html_nodes(url_res, xpath="/html/head/title")
url_title

# 抽出した要素を文字列へ変換
title = html_text(url_title)
title

# パイプ演算子(Ctrl+Shift+M)を使う場合
title2 = read_html(kabu_url) %>% 
  html_nodes(xpath="/html/head/title") %>% 
  html_text()
title2  

# 表形式のデータを取得
kabuka = read_html(kabu_url) %>% 
  html_node(xpath="//*[@id='stock_kabuka_table']/table[2]") %>% 
  html_table()
head(kabuka, 10)

# 複数のページから取得
# for文の中で要素を付け加えておくオブジェクトはfor文の外にあらかじめ空のオブジェクトの用意が必要となる
urls = NULL
kabukas = list()

base_url = "https://kabutan.jp/stock/kabuka?code=0000&ashi=day&page="

# 1~5に対して同じ処理を繰り返す
for (i in 1:5){
  pgnum = as.character(i)
  urls[i] = paste0(base_url, pgnum)
  
  kabukas[[i]] = read_html(urls[i]) %>% 
    html_node(xpath = "//*[@id='stock_kabuka_table']/table[2]") %>% 
    html_table() %>% 
    dplyr::mutate_at("前日比", as.character)
  
  # 1ページ取得したら1秒停止
  Sys.sleep(1)
}

dat = dplyr::bind_rows(kabukas)
dat
str(dat)


# ブラウザの自動操作 ---------------------------------------------------------------

install.packages("RSelenium")
library(RSelenium)
wdman::selenium(retcommand=TRUE)



