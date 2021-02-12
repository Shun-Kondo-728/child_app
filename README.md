# Chi-Sha
<img width="903" alt="スクリーンショット 2021-02-11 22 59 10" src="https://user-images.githubusercontent.com/69452885/107646520-668bf880-6cbd-11eb-9af8-9ff9b30ef1f1.png">

## アプリケーション概要
Ruby on Railsを独学で学び、このポートフォリオを作成しました。育児中、妊娠中の方に向けた育児共有サービスとなっております。育児・妊娠に関連付いた事を投稿することができます。

## URL
「ログイン」→「専用ログイン」をクリックしていただくと、テストユーザーとして各種機能をお試しいただけます。レスポンシブ対応しているのでスマホでもみることができます。

## このポートフォリオを作成した経緯
子供を授かり妊娠・育児を体験していく中で何をすればいいのかさっぱりわからず困っている人がたくさんいると思います。そこで、こういう育児共有サイトがあれば先輩ママ達から育児中や妊娠中にオススメのものやこと（おもちゃ・寝かしつけ方など）、悩みや不安に対する助言を教えてもらえるのではないかと思い作成しました。

## 使用技術
・ Ruby 2.6.6

・ Rails 5.2.4.4

・ Docker

・ Docker-compose

・ Nginx

・ Puma

・ MySQL 5.7

・ AWS

    ○ VPC
    
    ○ EC2

    ○ RDS for MySQL

    ○ ACM

    ○ ALB

・ RSpec（単体テスト・結合テスト・システムテスト）

## AWS構成図
![Untitled Diagram](https://user-images.githubusercontent.com/69452885/107664692-094d7280-6cd0-11eb-973c-c81ad696f9a9.png)

## 実装した機能
・ 2つの投稿機能（オススメ・悩み）

・ 画像を正方形に整形して投稿（CarrierWave）

・ フォロー機能（Ajax）

・ いいね（お気に入り）登録機能（Ajax・jQuery Raty）

・ コメント機能 

・ 通知機能（フォロー・いいね登録・コメントがあった場合）

・ 検索機能（ransack）

・ ログイン

・ ログイン状態の保持

・ ページネーション（kaminari）

・ DM機能  

## ポイント
・ 誰かの悩みを解決できるサービスにした

・ GitHubによるisuue管理を繰り返すことでチーム開発を見据えて開発を行った

・ RSpecによる豊富なテスト記述

・ Rubocopを用いたコード規約に沿った開発（静的コード解析）

・ デザインをシンプルにして使用方法をわかりやすくした

・ Bootstrapを用いたレスポンシブ対応


## 今後やりたいこと
・ DM通知・一覧機能

・ AWSの使ったことのない機能を使ってみたい

・ CircleCi CI/CD

