User.create!(
    [
      {
        name:  "鈴木 一郎",
        email: "suzuki@example.com",
        password:              "foobar",
        password_confirmation: "foobar",
        admin: true,
      },
      {
        name:  "佐藤 彩",
        email: "sato@example.com",
        password:              "password",
        password_confirmation: "password",
      },
      {
        name:  "山田 太郎",
        email: "saiyou@example.com",
        password:              "password",
        password_confirmation: "password",
      },
    ]
  )

  user1 = User.find(1)
  user2 = User.find(11)
  user3 = User.find(21)
  user1.follow(user3)
  user2.follow(user3)
  user3.follow(user1)
  user3.follow(user2)

  Post.create!(
    [
      {
        title: "赤ちゃんが泣き止まない時はこれ！",
        description: "このCMを流せば泣き止みます。
                      https://www.youtube.com/watch?v=iHGf0VNZNyk",
        recommended: 5,
        user_id: 1  
      },
      {
        title: "私が使うおもちゃはこれです",
        description: "これはすごくオススメです！ガラガラ音が鳴ります！",
        recommended: 4,
        picture: open("#{Rails.root}/app/assets/images/toy.jpeg"),
        user_id: 2
      },
      {
        title: "育児のコツ！",
        description: "赤ちゃんに自分たちの生活リズムを合わせさせるじゃなく自分達が合わせること！",
        recommended: 4,
        user_id: 3 
      },
      {
        title: "家族で写真を共有できるアプリ！",
        description: "このアプリは一番おすすめで、みんなが撮った写真をこのアプリ一つで見れてしまいます！
                      https://apps.apple.com/jp/app/%E5%AE%B6%E6%97%8F%E3%82%A2%E3%83%AB%E3%83%90%E3%83%A0-%E3%81%BF%E3%81%A6%E3%81%AD/id935672069",
        recommended: 5,
        picture: open("#{Rails.root}/app/assets/images/tomato.jpeg"),
        user_id: 1  
      },
      {
        title: "このおもちゃで赤ちゃんの機嫌が良くなります。",
        description: "最初の頃はダメでしたが使い込んでくると効果が現れます！是非使ってみてください！",
        recommended: 3,
        picture: open("#{Rails.root}/app/assets/images/rabbit.jpeg"),
        user_id: 2
      },
      {
        title: "オルゴールを流せば泣き止む！",
        description: "オルゴールを聞くと落ち着くのかすぐ泣き止みます！",
        recommended: 3,
        user_id: 3
      },
      {
        title: "この道具が便利で最高！",
        description: "これは買ってみる価値あり！！
                      https://www.amazon.co.jp/KJC-%E3%82%A8%E3%82%B8%E3%82%BD%E3%83%B3%E3%83%9E%E3%83%9E-EDISONmama-%E3%82%AB%E3%83%9F%E3%82%AB%E3%83%9FBaby%E3%83%90%E3%83%8A%E3%83%8A/dp/B07C6C53QG",
        recommended: 5,
        picture: open("#{Rails.root}/app/assets/images/banana.jpeg"),
        user_id: 1  
      },
      {
        title: "うちの子供はこれを使えば落ち着きます",
        description: "もしよかったら試してみてください！触るとシャカシャカ鳴って笑顔になります！！",
        recommended: 4,
        picture: open("#{Rails.root}/app/assets/images/book.jpeg"),
        user_id: 2
      },
      {
        title: "私はこの動画がオススメ！",
        description: "この動画を見せると機嫌が良くなります。
                      https://www.youtube.com/watch?v=bR1FUKzznw8&t=1202s",
        recommended: 5,
        picture: open("#{Rails.root}/app/assets/images/tomato.jpeg"),
        user_id: 3
      },
      {
        title: "個人的オススメなおもちゃはこれ！",
        description: "これは半年くらいからオススメかも？フワフワで寝心地が良さそう！",
        recommended: 2,
        picture: open("#{Rails.root}/app/assets/images/bed.jpeg"),
        user_id: 1  
      },
      {
        title: "夜泣きしたときには！",
        description: "子供が夜泣きしたときは胸をポンポンと優しく叩いてあげて、顔を近づけて安心感を生み出すのがコツです！",
        recommended: 4,
        user_id: 2
      },
      {
        title: "育児にオススメな道具はこれ",
        description: "これを使うと消毒ができます！消毒大事！！
                      https://www.amazon.co.jp/%E3%80%90%E6%97%A5%E6%9C%AC%E8%A3%BD%E3%80%91%E3%82%B3%E3%83%B3%E3%83%93-%E9%9B%BB%E5%AD%90%E3%83%AC%E3%83%B3%E3%82%B8%E9%99%A4%E8%8F%8C-%E4%BF%9D%E7%AE%A1%E3%82%B1%E3%83%BC%E3%82%B9-%E9%99%A4%E8%8F%8C%E3%81%98%E3%82%87-%E3%81%9A%CE%B1-%E3%83%90%E3%83%8B%E3%83%A9/dp/B00D2IAEVW/ref=sr_1_18?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&dchild=1&keywords=%E8%B5%A4%E3%81%A1%E3%82%83%E3%82%93+%E6%B6%88%E6%AF%92&qid=1610873865&s=baby&sr=1-18",
        recommended: 4,
        picture: open("#{Rails.root}/app/assets/images/box.jpeg"),
        user_id: 3
      },
      {
        title: "赤ちゃんの機嫌を良くするには！",
        description: "このおもちゃを使うとうちの子は機嫌が良くなります！いろいろな種類があるので是非買ってみてください！",
        recommended: 4,
        picture: open("#{Rails.root}/app/assets/images/remocon.jpeg"),
        user_id: 1  
      },
      {
        title: "赤ちゃんを可愛く撮れるアプリはこのアプリ！",
        description: "赤ちゃんがより一層可愛く撮れます！加工なしでも可愛いんですけどね笑
                      https://apps.apple.com/jp/app/b612-%E3%81%84%E3%81%A4%E3%82%82%E3%81%AE%E6%AF%8E%E6%97%A5%E3%82%92%E3%82%82%E3%81%A3%E3%81%A8%E6%A5%BD%E3%81%97%E3%81%8F/id904209370?mt=8",
        recommended: 4,
        user_id: 2
      },
      {
        title: "うちの子の可愛い服はこれ！",
        description: "寝るとき着せると手足を広げて星みたいになり可愛いです！",
        recommended: 5,
        picture: open("#{Rails.root}/app/assets/images/star.jpeg"),
        user_id: 3
      }
    ]
   )

   post2 = Post.find(2)
   post6 = Post.find(6)
   post8 = Post.find(8)
   post9 = Post.find(9)
   post12 = Post.find(12)
   post13 = Post.find(13)
   post14 = Post.find(14)
   post15 = Post.find(15)

   user3.like(post2)
   user3.like(post8)
   user3.like(post13)
   user3.like(post14)
   user2.like(post6)
   user1.like(post9)
   user1.like(post12)
   user2.like(post15)

   # コメント
   post6.comments.create(user_id: user2.id, content: "とてもいいですね！！")
   post12.comments.create(user_id: user1.id, content: "使ってみます！")
   post15.comments.create(user_id: user2.id, content: "参考になります！")

   comment1 = Comment.find(1)
   comment2 = Comment.find(2)
   comment3 = Comment.find(3)

   Problem.create!(
      [
        {
          description: "どうしたら泣き止んでくれるのだろう。。",
          user_id: 1  
        },
        {
          description: "うちの子咳が止まらないんですけど大丈夫かな？？",
          user_id: 2
        },
        {
          description: "産まれてから環境が変わって少し辛い。",
          user_id: 3  
        },
        {
          description: "旦那が何も手伝ってくれなくてストレスがたまる。どうしたらいいですかね？",
          user_id: 1  
        },
        {
          description: "産まれてから生理不順になって心配。大丈夫かな。。",
          user_id: 2  
        },
        {
          description: "私うまく育児やっていけるのか心配！！！",
          user_id: 3  
        },
        {
          description: "夜泣きで起こされてなかなか眠れなくて寝不足。。",
          user_id: 1  
        },
        {
          description: "初めての育児で何からやっていけば良いかわからない。。",
          user_id: 2  
        },
        {
          description: "離乳食は何から食べさせれば良いのかな？",
          user_id: 3  
        },
        {
          description: "うちの子なかなか泣き止まないんですけど何かいい方法はありますか？？",
          user_id: 1  
        },
        {
          description: "ストレスが溜まってきてヤバい。。ストレス解消ストレス解消方法はありますか？",
          user_id: 2
        },
        {
          description: "疲れがなかなかとれないです。",
          user_id: 3  
        }
      ]
   )

   problem2 = Problem.find(2)
   problem8 = Problem.find(8)
   problem10 = Problem.find(10)

   problem2.problem_comments.create(user_id: user1.id, content: "一度病院に行ってみた方がいいですね。")
   problem8.problem_comments.create(user_id: user2.id, content: "焦らずいきましょう！")
   problem10.problem_comments.create(user_id: user1.id, content: "子供の動画など見せるといいですよ！")

   problem_comment1 = ProblemComment.find(1)
   problem_comment2 = ProblemComment.find(2)
   problem_comment3 = ProblemComment.find(3)
