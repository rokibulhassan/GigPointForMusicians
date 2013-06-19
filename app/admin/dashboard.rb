ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc { I18n.t("active_admin.dashboard") }

  content :title => proc { I18n.t("active_admin.dashboard") } do

    div do
      h3 "Recent Activity"
    end

    columns do
      column do
        panel "Venues" do
          ul do
            Venue.recently_created(5).map do |venue|
              li link_to(venue.name, admin_venue_path(venue))
            end
          end
        end
        panel "Artists" do
          ul do
            Artist.recently_created(5).map do |artist|
              li link_to(artist.name, admin_artist_path(artist))
            end
          end
        end
      end
    end
  end
end
