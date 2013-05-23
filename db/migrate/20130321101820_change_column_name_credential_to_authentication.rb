class ChangeColumnNameCredentialToAuthentication < ActiveRecord::Migration
  def up
    rename_column :authentications, :credential, :credentials
  end

  def down
    rename_column :authentications, :credentials, :credentials
  end
end
