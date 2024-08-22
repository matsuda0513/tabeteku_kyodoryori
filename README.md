# タイトル
  食べてく？郷土料理を巡る旅  
  （英語版：EAT & WONDER -EXPLORING REGIONAL CUISINE-）  
  - 日本語版  
  ![logo_white](https://github.com/user-attachments/assets/33cbcbfc-eae0-471d-8b8f-663398527695)

  - 英語版  
  ![logo_e_white](https://github.com/user-attachments/assets/e185401e-2833-4829-8899-0b353387399f)


# アプリ概要
  郷土料理を検索し、飲食店検索、レシピ検索、写真検索などに繋げ、実際に食べることに繋げる。

  ## 作成した背景  
  - コロナ禍では多くの国民が海外への渡航が叶わず国内旅行をする機会が増え、日本の新たな魅力に気づいた方も多かった。その一方でコロナ禍が明けてからは多くの訪日外国人が日本を訪れている。  
  - 日本の魅力は、清潔さ、ホスピタリティ、島国ならではの独自の歴史・文化に加え、それに基づいた食文化があり、代表的な和食以外に数多くの料理が全国各地に存在する。  
  - 郷土料理の中には地方の少子高齢化や食文化の変化に伴い、存続の危機にある料理もある。  
  - 観光客が、その土地に旅行で観光地を巡るとともに、料理を知ること、そしてそこから実際に食すことで、和食文化を守っていく一助となればという思いで制作。

  ## 工夫したポイント
  - データベースは農林水産省が監修したデータベース（うちの郷土料理/3年で47都道府県1365品の郷土料理を監修/前職で担当）を使用することで、正確な情報を掲載。
  - 食べログ検索では、店名を含んだ検索ではなく口コミ・お店情報から郷土料理名を検索し、精度の高い検索結果を表示。
  - 英語版では、日本語版のデータベースを紐付け、検索機能では日本語の検索結果を自動翻訳することで、精度の高い検索結果を表示。
  （訪日外国人向けのお店検索等は、寿司・焼肉などのメジャーではない料理検索サイトはない。また、ローマ字検索だとヒットしないため、日本語版を翻訳した。）


# URL
  日本語版：https://tabeteku-kyodoryori.onrender.com/  
  英語版：https://tabeteku-kyodoryori.onrender.com/english
  - Basic認証ID admin  
  - Basic認証PW 2222

# 使用技術
  ruby 3.2.0p0  
  Ruby on rails 7.0.8.4  
  Javascript  
  HTML/CSS  
  Mysql 0.5.6  

# 機能一覧
  ## 1_郷土料理検索(日本語、ローマ字)
  #### 日本語検索  
[![Image from Gyazo](https://i.gyazo.com/365d42a078f3268eddacef3b0f1971ee.gif)](https://gyazo.com/365d42a078f3268eddacef3b0f1971ee)  

  #### ローマ字検索  
[![Image from Gyazo](https://i.gyazo.com/3e9f00060a4634ff67c25e16f3e33c46.gif)](https://gyazo.com/3e9f00060a4634ff67c25e16f3e33c46)

  ## 2_郷土料理一覧(プルダウンで県別一覧表示)  
  #### 日本語
[![Image from Gyazo](https://i.gyazo.com/4cd4b2f255ca4639faf0a256a6d86f22.jpg)](https://gyazo.com/4cd4b2f255ca4639faf0a256a6d86f22)

  #### 英語  
[![Image from Gyazo](https://i.gyazo.com/75a5ead790d6b9a3127c440c2864cd28.jpg)](https://gyazo.com/75a5ead790d6b9a3127c440c2864cd28)

  ## 3_郷土料理詳細
   ### 3-1_レストラン検索（食べログ連携）

  #### 日本語  
[![Image from Gyazo](https://i.gyazo.com/7ba7b7f4b9c513d2b1392ed7d57b2ef6.gif)](https://gyazo.com/7ba7b7f4b9c513d2b1392ed7d57b2ef6)  

  #### 英語  
[![Image from Gyazo](https://i.gyazo.com/076de21c77ab31a052d869b30f7933b6.gif)](https://gyazo.com/076de21c77ab31a052d869b30f7933b6)  

   ### 3-2_レシピ検索(Cookpad連携)
   #### 日本語  
[![Image from Gyazo](https://i.gyazo.com/0827235f26d5e0663b040ff3ab26f31f.gif)](https://gyazo.com/0827235f26d5e0663b040ff3ab26f31f)  

  #### 英語  
[![Image from Gyazo](https://i.gyazo.com/fd5cec8d002cc74d27fbdf90e4fd7095.gif)](https://gyazo.com/fd5cec8d002cc74d27fbdf90e4fd7095) 

   ### 3-3_写真検索(Instagram連携)

# データベース設計
![datebesev2](https://github.com/user-attachments/assets/a7140922-81ed-4235-8e7f-843afe780296)

# 画面遷移図
  ![test_whitev3](https://github.com/user-attachments/assets/c3dc7ed8-5fc8-4f65-8853-e4123685ef12)

