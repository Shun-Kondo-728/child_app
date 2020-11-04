User.create!(name:  "鈴木 一郎",
    email: "sample@example.com",
    password:              "foobar",
    password_confirmation: "foobar",
    admin: true)

20.times do |n|
    Post.create!(title: "赤ちゃんが泣き止まない時はこれ！",
                 description: "この曲を流せば泣き止みます",
                 recommended: 4,
                 user_id: 1)
end

99.times do |n|
name  = Faker::Name.name
email = "sample-#{n+1}@example.com"
password = "password"
User.create!(name:  name,
      email: email,
      password:              password,
      password_confirmation: password)
end

users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }