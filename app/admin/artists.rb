ActiveAdmin.register Artist do
  filter :profile_name, :as => :string
  filter :email

  index do
    column :name, :sortable => 'artist.profile.name' do |resource|
      link_to resource.profile.name, resource_path(resource) unless resource.profile.nil?
    end

    column :phone do |resource|
      resource.profile.phone unless resource.profile.nil?
    end


    column :website_url do |resource|
      resource.profile.website_url unless resource.profile.nil?
    end

    column :booking

    column "Action" do |resource|
      links = ''.html_safe
      links += link_to "Edit", edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to "Destroy", resource_path(resource), :method => :delete, :confirm => "Are you Sure?", :class => "member_link delete_link"
      links
    end
  end

  show do |artist|
    attributes_table do

      row :profile_picture do
        image_tag artist.profile.photo.url(:thumb) rescue image_tag "/photos/thumb/missing.png"
      end

      row :name do
        artist.profile.name
      end

      row :phone do
        artist.profile.phone
      end

      row :email

      row :website_url do
        artist.profile.website_url
      end

      row :booking

      row :bio do
        artist.profile.bio
      end

      row :description

    end
  end

  form :partial => "/admin/artist/form"

end
