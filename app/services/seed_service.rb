require 'open-uri'

class SeedService
  def self.seed
    # abort JSON.parse(File.read(Rails.root.join('db', 'posts.json')))['posts'].inspect
    ActiveStorage::Attachment.all.each { |attachment| attachment.purge }
    TeamMembership.delete_all
    Team.delete_all
    Comment.delete_all
    Post.delete_all
    ProjectUser.delete_all
    Project.delete_all
    User.delete_all
    ['active_storage_blobs', 'active_storage_attachments', 'posts', 'projects', 'projects_users', 'team_memberships', 'teams', 'users', 'comments'].each do |table_name|
      ActiveRecord::Base.connection.execute("TRUNCATE #{table_name} RESTART IDENTITY CASCADE")
    end

    teams = []
    teams.push(FactoryBot.create(:team, name: 'Apple', url: 'https://apple.com'))
    teams.push(FactoryBot.create(:team, name: 'Google', url: 'https://google.com'))
    teams.push(FactoryBot.create(:team, name: 'Facebook', url: 'https://facebook.com'))
    teams.push(FactoryBot.create(:team, name: 'Amazon', url: 'https://amazon.com'))

    demo_user = User.create(
      first_name: 'Avo',
      last_name: 'Cado',
      email: 'avo@cado.com',
      password: 'secret',
      active: true,
      roles: {
        admin: true,
        manager: true,
        editor: true,
      },
      birthday: Faker::Date.birthday(min_age: 18, max_age: 65),
    )

    users = [demo_user]
    38.times do
      users.push(FactoryBot.create(:user, team_id: teams.sample.id))
    end

    users.push User.create(
      first_name: "Avo",
      last_name: "Cado",
      email: "avo@avohq.io",
      birthday: "2020-03-28",
      password: SecureRandom.hex,
      active: true,
      roles: {
        admin: true,
        manager: false,
        writer: false
      }
    )

    posts = JSON.parse(File.read(Rails.root.join('db', 'posts.json')))['posts']
    posts.reverse.each do |post_payload|
      post = Post.create(
        name: CGI::unescapeHTML(post_payload['title']),
        body: CGI::unescapeHTML(post_payload['content']),
        is_featured: [true, false].sample,
        custom_css: ".header {\n  color: red;\n}",
        user_id: users.sample.id,
        published_at: post_payload['pubDate'],
        created_at: post_payload['pubDate'],
        updated_at: post_payload['pubDate'],
      )

      post.cover_photo.attach(io: URI.open(post_payload['thumbnail']), filename: 'cover.jpg')

      rand(0..15).times do
        post.comments << FactoryBot.create(:comment, user_id: users.sample.id)
      end
    rescue => exception
      puts exception.inspect
    end

    projects = []
    30.times do
      projects.push(FactoryBot.create(:project))
    end

    # assign users to teams
    teams.each do |team|
      users.shuffle[0..rand(5...15)].each_with_index do |user, index|
        team.members << user

        membership = team.memberships.find_by user_id: user.id
        membership.update level: [:beginner, :intermediate, :advanced].sample

        if index == 0
          membership.update level: :admin
        end
      end
    end

    # assign users to projects
    projects.each do |project|
      users.shuffle[0..10].each do |user|
        project.users << user
      end

      rand(0..15).times do
        project.comments << FactoryBot.create(:comment, user_id: users.sample.id)
      end
    end

    # Create this last user so the grid view displays the gravatar image for an entry
    User.create(
      first_name: 'Avo',
      last_name: 'Cado',
      email: 'avo@avohq.io',
      password: 'secret',
      active: true,
      roles: {
        admin: true,
        manager: true,
        editor: true,
      },
      birthday: Faker::Date.birthday(min_age: 18, max_age: 65),
    )
  end
end