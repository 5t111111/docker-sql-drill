# SQL 書き方ドリルのサンプル DB を re:dash で遊べるようにする docker-compose

この docker-sql-drill は、__「改訂第3版 すらすらと手が動くようになる SQL書き方ドリル」__ を Re:dash + Docker で遊べるようにするためのものです。

- [技術評論社 (電子書籍版もあり)](http://gihyo.jp/book/2016/978-4-7741-8066-3)
- [Amazon](www.amazon.co.jp/dp/4774180661)

ネタ元: [SQL書き方ドリルのサンプルDBをre:dashで遊べるようにするVagrantfile](http://ariarijp.hatenablog.com/entry/2016/09/05/140559)

## 特徴

- Docker コンテナを起動すればすぐにデータベースがセットアップされている
- Re:dash 上でクエリを実行できる
- データソースに MySQL/PosrgreSQL のいずれかを利用できる

## 使うために必要なもの

- Docker (docker-compose) 実行環境
- 書籍付属 CD-ROM のデータ、もしくは gihyo のサイトからダウンロードしたデータ

## 使いかた

### リポジトリのクローン

```
$ git clone https://github.com/5t111111/docker-sql-drill.git
$ cd docker-sql-drill
```

### サンプルデータベース用のファイルの準備

書籍付属 CD-ROM のデータ、もしくは gihyo のサイトからダウンロードしたしたデータを展開し、リポジトリの直下に `SQL_DRILL` というディレクトリが作成されるように配置してください。

```
.
├── README.md
├── SQL_DRILL <= これ
├── create_redash_database.sh
├── docker-compose.yml
├── docker-entrypoint-initdb-mysql.d
└── docker-entrypoint-initdb-postgres.d
```


### Docker コンテナの起動

docker-sql-drill は複数のコンテナから構成されているため docker-compose で起動します。

```
$ docker-compose up
```

これでコンテナが起動しますが、この時点では Re:dash のシステム用のデータベースが準備されていないため、Re:dash に接続できず、ログにもエラーが出ている状態です。

### Re:dash のシステム用データベースのセットアップ

以下のスクリプトを実行して Re:dash 用のデータベースをセットアップしてください。

```
$ ./create_redash_database.sh
```

### Re:dash への接続

http://localhost:9001 に接続します。

- Email: admin
- Password: admin

でログインできます。

### データソースの追加

#### MySQL データソース

1. メニューの右上の方にあるストレージ型のアイコンをクリック
2. 「+ New Data Source」をクリック
3. 「Type」に「MySQL」を選択
4. 以下を入力
  - Name: MySQL (任意なのでなんでもOK)
  - Database name: sql_drill
  - Host: `docker ps` で出力される MySQL のコンテナ名 (通常は「__dockersqldrill_mysql_1__」になる)
  - Password: sql_drill
  - Port: 3306
  - User: sql_drill
  - その他空欄のまま
5. 「Save」をクリック

#### PostgreSQL データソース

1. メニューの右上の方にあるストレージ型のアイコンをクリック
2. 「+ New Data Source」をクリック
3. 「Type」に「PostgreSQL」を選択
4. 以下を入力
  - Name: PostgreSQL (任意なのでなんでもOK)
  - Database name: sql_drill
  - Host: `docker ps` で出力される PostgreSQL のコンテナ名 (通常は「__dockersqldrill_postgres_1__」になる)
  - Password: sql_drill
  - Port: 5432
  - User: sql_drill
  - その他空欄のまま
5. 「Save」をクリック

### SQL クエリの実行

1. メニューの「Queries」->「New Query」を選択
2. 「Data Source」からデータソースを選択

...後は完全に一般的な Re:dash の使いかたになるための省略します。

## 補足

- データは docker-compose で定義された volume によって永続化されます
- MySQL/PostgreSQL には外部からのアクセスができないようになっています。必要であれば `docker-compose.yml` を修正し、ポートを公開するようにしてください
- PostgreSQL の DB には Re:dash のシステムデータが含まれるため、もし MySQL しかデータソースに使わない場合もデータを消去せず、必ず起動してください
- セキュリティの設定などは適当です。あくまでも書籍の学習用途としてご利用ください

## 構成

おまけですが、`docker-sql-drill` は以下の Docker コンテナから構成されます。

- redash: Re:dash アプリケーション用コンテナ
- postgres: PostgreSQL データソース/Re:dash システムデータ用コンテナ
- mysql: MySQL データソース用コンテナ
- nginx: Web サーバー用コンテナ
- redis: Re:dash で利用する Redis 用コンテナ
