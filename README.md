# hello-amx-a

hello-amx-a

![hello-amx-a](https://repository-images.githubusercontent.com/600631240/c9f95a15-6a4a-4dd0-af76-29f74992c3c4)

# Demo

## a) Hello

[amx-project/a](https://github.com/amx-project/a) の公開する pmtiles を 1 枚の HTML で簡単に表示することを目的としたサンプルです。

- <https://frogcat.github.io/hello-amx-a/hello/>

## b) XSLT

ダウンロードした法務省登記所備付地図データ XML の先頭部分に `<?xml-style-sheet?>` を設定し、
ブラウザで XML ビューの代わりに HTML と SVG によるビューが表示されるか？というトライです。

```
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="style.xsl"?>
<地図 xmlns="http://www.moj.go.jp/MINJI/tizuxml" xmlns:zmn="http://www.moj.go.jp/MINJI/tizuzumen" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.moj.go.jp/MINJI/tizuxml tizuxml.xsd">
	<version>ver1.0</version>
	<地図名>宇田川町（１／６００）</地図名>
	<市区町村コード>13113</市区町村コード>
	<市区町村名>渋谷区</市区町村名>
	<座標系>任意座標系</座標系>
```

- <https://frogcat.github.io/hello-amx-a/xslt/13113-0110-1.xml>
- <https://frogcat.github.io/hello-amx-a/xslt/13113-0110-44.xml>

# References

- <https://front.geospatial.jp/houmu-chiseki/>
- <https://github.com/amx-project/a>
- <https://github.com/amx-project/a-spec>
