ActiveAdmin.register Artist do
  filter :name
  filter :email

  index do
    column :name, :sortable => 'artist.name' do |resource|
      link_to resource.name, resource_path(resource)
    end
    column :email
    column :url
    column :tel
    column :booking
    column :description
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
      row :name
      row :email
      row :tel
      row :booking
      row :description
    end
  end

  form :partial => "/admin/artist/form"

end
