25.times do
    user = User.create(
        name: Faker::Name.name,
        email: Faker::Internet.safe_email,
        username: Faker::Internet.username,
        password: "testtest")
    
    15.times do
        create_date = Faker::Date.backward(days: 300)
        Journal.create(
            title: Faker::TvShows::Buffy.episode,
            date: create_date,
            content: Faker::Lorem.paragraphs(number: 3).join("/n/n"),
            user_id: user.id,
            created_at: create_date,
            updated_at: create_date)
    end
end