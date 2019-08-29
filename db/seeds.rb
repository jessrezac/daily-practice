Journal.destroy_all
User.destroy_all

5.times do
    user = User.create(
        name: Faker::Name.name,
        email: Faker::Internet.safe_email,
        username: Faker::Internet.username,
        password: "testtest")
    
    10.times do
        create_date = Faker::Date.backward(days: 300)
        Journal.create(
            title: Faker::TvShows::Buffy.episode,
            date: create_date,
            content: Faker::Hipster.paragraphs(number: 3).join("\r\n"),
            user_id: user.id,
            created_at: create_date,
            updated_at: create_date)
    end
end