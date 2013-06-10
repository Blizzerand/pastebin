class AddRememberTokenToPages < ActiveRecord::Migration
  def change
  	add_column :pages, :remember_token, :string
  	add_index :pages, :remember_token
  	
  end
end
